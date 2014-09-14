<#

.DESCRIPTION
    Deploys a Web App to Azure using the *.publishSettings

.EXAMPLE
    PS C:\>

#>
#Requires -Version 3.0

param (
    [Parameter(Position=0, Mandatory, HelpMessage="Azure Publish Settings, downloaded from the management portal")]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [ValidatePattern("\.PublishSettings$")]
    [string]$SourcePublishSettings,

    [Parameter(Position=1, Mandatory, HelpMessage="The packaged application to install")]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [ValidatePattern("\.zip$")]
    [string]$Package,
        
    [Parameter(Position=2, Mandatory, HelpMessage="Configure package parameters")]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [ValidatePattern("\.xml$")]
    [string]$Parameters,

    [Parameter(HelpMessage="Launch the Azure Website after deploy")]
    [switch]$Launch
)

# Error handling
$ErrorActionPreference = "Stop"
trap
{
    $Host.UI.WriteErrorLine($_)
    Exit 1
}

# Set debug
$debug = ($PSBoundParameters.Debug -eq $true)
if ($debug) {
    $DebugPreference = "Continue"
}

function Get-WebDeployLocation {
    $installPath = (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\IIS Extensions\MSDeploy" | Select -last 1).GetValue("InstallPath")
    return (Join-Path $installPath "msdeploy.exe")
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

# Use a temporary location to avoid path too long or containing spaces isssue
$temporaryLocation = New-TemporaryLocation

Copy-Item $SourcePublishSettings -Destination $temporaryLocation
Copy-Item $Package -Destination $temporaryLocation
Copy-Item $Parameters -Destination $temporaryLocation

Push-Location $temporaryLocation

    # Read from *.PublishSettings file
    [xml]$settings = Get-Content "$SourcePublishSettings"
    $publishProfile = $settings.publishData.publishProfile.get(0)

    $publishUrl = $publishProfile.publishUrl
    $sitename = $publishProfile.msdeploySite
    $userName = $publishProfile.userName
    $password = $publishProfile.userPWD

    $msdeploy = Get-WebDeployLocation
    $deployParams = @(
        "-verb:sync",
        "-source:package=`"$(Resolve-Path $Package)`"",
        "-dest:iisapp=$sitename,computername=https://$publishUrl/msdeploy.axd?site=$sitename,username=$userName,password=$password,authtype=basic"
        "-setParamFile:`"$(Resolve-Path $Parameters)`""
        "-allowUntrusted",
        "-verbose"
    )

    Write-Output "Publishing $Package to Azure Web Site $siteName"
    Write-Debug "$deployParams"

    & $msdeploy $deployParams | %{ Write-Output "$_" }

Pop-Location

if (-not $debug) {
    # Clean up, remove the temporary working directory
    Remove-Item -Path $temporaryLocation -Recurse -Force | Out-Null
}

if ($Launch) {
    Show-AzureWebsite -Name $sitename 
}
