<#

.DESCRIPTION
    Packages a release of Ghost (https://github.com/TryGhost/Ghost) for the Microsoft Azure App Gallery, i.e. ready to install.

.EXAMPLE
    PS C:\{Ghost-Config-Repository}\azure>.\Package.ps1 -GhostZip ".\ghost-0.5.1.zip"

#>
#Requires -Version 3.0

param (
    [Parameter(Position=0, Mandatory, HelpMessage="A ZIP file Ghost release, from https://github.com/TryGhost/Ghost/releases")]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [ValidatePattern("\.zip$")]
    [string]$GhostZip
)

# Error handling
$ErrorActionPreference = "Stop"
trap
{
    Pop-Location
    $Host.UI.WriteErrorLine($_)
    Exit 1
}

# Set verbosity
$verbose = ($PSBoundParameters.Verbose -eq $true)
if ($verbose) {
    $VerbosePreference = "Continue"
}

# Set debug
$debug = ($PSBoundParameters.Debug -eq $true)
if ($debug) {
    $DebugPreference = "Continue"
}

function Expand-Zip {
    param (
        [Parameter(Position=0, Mandatory)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [ValidatePattern("\.zip$")]
        [string]$ArchiveFile,

        [Parameter(Position=1, Mandatory)]
        [ValidateNotNullorEmpty()]
        [string]$Destination
    )

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
    [System.IO.Compression.ZipFile]::ExtractToDirectory((Resolve-Path $ArchiveFile), (Resolve-Path $Destination))
}

function Compress-Zip {
    param (
        [Parameter(Position=0, Mandatory)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$Source,

        [Parameter(Position=1, Mandatory)]
        [ValidateNotNullorEmpty()]
        [ValidatePattern("\.zip$")]
        [string]$ArchiveFile
    )

    # If there is a problem loading the DLL, open the file properties and click 'Unblock'
    Push-Location $PSScriptRoot
        [System.Reflection.Assembly]::LoadFrom((Resolve-Path .\Ionic.Zip.Reduced.dll)) | Out-Null
    Pop-Location

    $zipFile = New-Object Ionic.Zip.ZipFile
    $zipFile.AddDirectory($Source)
    $zipFile.Save($ArchiveFile)
    $zipFile.Dispose()
}

function Get-SHA1Hash {
    param (
        [Parameter(Position=0, Mandatory)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$Filename
    )

    $result = ""
    $file = $null

    try {
        $file = [System.IO.File]::Open($Filename, "open", "read")
        [Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
        (New-Object System.Security.Cryptography.SHA1Managed).ComputeHash($file) | %{ $result = $result + $_.ToString("x2") }
    } finally {
        if ($file -ne $null) {
            $file.Dispose()
        }
    }

    return $result
}

function New-TemporaryLocation {
    # Unable to use $env:temp as it can result in a path longer than 248 characters or containing spaces
    # Instead find the largest local drive
    $drive = (Get-Volume | Sort-Object -Property SizeRemaining -Descending | Select -First 1).DriveLetter
    $name = [System.Guid]::NewGuid().ToString()
    $location = Join-Path "$drive`:" $name

    New-Item -ItemType Directory -Force -Path $location | Out-Null
    return $location
}

function ConvertFrom-Utf8 {
    if ([string]::IsNullOrEmpty($_)) {
        return
    }

    return ($_ -replace '[^\u0000-\u007F]','')
}

$packageRoot = New-TemporaryLocation
$ghostInstallation = Join-Path $packageRoot "Ghost"

if ($debug) {
    # Open location that we are packaging
    Invoke-Item $packageRoot
}

# Unpack the Ghost installation to a temporary directory
Write-Output "Expanding $GhostZip to $ghostInstallation"
Expand-Zip $GhostZip $ghostInstallation

Push-Location $ghostInstallation

    # Node outputs warn messages as part of the npm install, these should not stop the script
    $ErrorActionPreference = "Continue"

    # Install Node Modules
    Write-Output "Installing Node Modules"
    & npm install --production | %{ $_ | ConvertFrom-Utf8 | Write-Verbose }

    # Install node-sqlite3 bindings for both the 32 and 64-bit Windows architecture.
    # node-sqlite3 will build the bindings using the system architecture and version of node that you're running the install

    # Force install of the 32-bit version, then move the lib to temporary location
    Write-Output "Installing SQLite3 x32 Module"
    & npm install sqlite3 --target_arch=ia32 | %{ $_ | ConvertFrom-Utf8 | Write-Verbose }
    Move-Item ".\node_modules\sqlite3\lib\binding\node-v11-win32-ia32\" -Destination ".\temp"

    # Force install of the 64-bit version, then copy 32-bit back
    Write-Output "Installing SQLite3 x64 Module"
    & npm install sqlite3 --target_arch=x64 | %{ $_ | ConvertFrom-Utf8 | Write-Verbose }
    Move-Item ".\temp" -Destination ".\node_modules\sqlite3\lib\binding\node-v11-win32-ia32\"

    $ErrorActionPreference = "Stop"

Pop-Location

# Package result to submit to Azure
$ghostAzureZip = Join-Path $PSScriptRoot "azure-$(Get-ChildItem $GhostZip | %{ $_.BaseName }).zip"

# Zip File Structure
# $ghostAzureZip
# |-- manifest.xml
# |-- parameters.xml
# |-- TBEX.xml
# |-- ThirdPartyLicense.txt
# |-- Ghost
# |   |-- config.js
# |   |-- iisnode.yml
# |   |-- web.config
# |   |-- * 

Write-Output "Packaging Ghost for Azure Web App Gallery"
Push-Location $PSScriptRoot

    # Copy Ghost configuration
    Copy-Item ".\Ghost\config.js" -Destination $ghostInstallation
    Copy-Item ".\Ghost\iisnode.yml" -Destination $ghostInstallation
    Copy-Item ".\Ghost\web.config" -Destination $ghostInstallation

    # Copy package metadata and license information
    Copy-Item ".\manifest.xml" -Destination $packageRoot
    Copy-Item ".\parameters.xml" -Destination $packageRoot
    Copy-Item ".\TBEX.xml" -Destination $packageRoot
    Copy-Item ".\ThirdPartyLicense.txt" -Destination $packageRoot

Pop-Location

# Remove previous package
if (Test-Path $ghostAzureZip) {
    Remove-Item -Path $ghostAzureZip -Force | Out-Null
}

Compress-Zip $packageRoot $ghostAzureZip

# Create a SHA-1 key of the ZIP file. It will be required during submission of the package to Azure.
Write-Output "Calculating SHA-1 hash"
$ghostAzureZipHash = Get-SHA1Hash $ghostAzureZip
$ghostAzureZipHash | Set-Content -Path (Join-Path $PSScriptRoot "$(Get-ChildItem $ghostAzureZip | %{ $_.BaseName }).sha1")

Write-Output "Packaged Ghost as $ghostAzureZip, SHA-1: $ghostAzureZipHash"
Write-Host "SUCCESS" -ForegroundColor Green

if (-not $debug) {
    # Clean up, remove the temporary working directory
    Remove-Item -Path $packageRoot -Recurse -Force | Out-Null
}
