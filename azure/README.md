# Ghost - Azure Gallery App

This package contains configuration files that are required to submit Ghost as a package to the [Azure App Gallery](http://www.microsoft.com/web/gallery/developer.aspx).

## Getting Started

Submission to the Azure App Gallery requires _all_ of the Ghost module dependencies - this includes `node_modules`.  Prior to getting started, please review the [Ghost installation instructions](https://github.com/TryGhost/Ghost/blob/master/CONTRIBUTING.md#installation--setup-instructions). It is not necessary to clone straight from GitHub, the packaged official ZIP file should be sufficient. This also keeps the number of files and the total file size down, since one can assume that all users who whish to have an active Git repo on their Azure Website would find cloning themselves to be more convenient. 

### Publish Instructions

Note that this package is not only intended to target Azure, but all Windows PCs in general - it has to handle 32 and 64-bit Windows architecture.  It is required that you build this package with a 64-bit Windows machine.

#### Ensure Azure compatibility

First, ensure that the official 'vanilla' ZIP version runs smoothly on Azure. 

1. Download the ZIP file
2. Run 'npm install'
3. Set up the config.js - Specifically, it is required that you replace ports with `process.env.PORT`.
4. Upload via FTP or GIT to an Azure Website and confirm that Ghost performs as expected

#### Creating a Web App Gallery Package

A Windows Web App Package has essentially only two major components: The Ghost folder after `npm install` has been run and a set of three configuration files. 

1. Download the ZIP version of the Ghost version you'd like to package up as a Windows Web App Package and run `npm install`. 

2. Install `node-sqlite3` bindings for both the 32 and 64-bit Windows architecture. `node-sqlite3` will build the [bindings](https://github.com/mapbox/node-sqlite3/wiki/Binaries) using the system architecture and version of node that you're running the install from.  So, this will require 64-bit Windows and 64-bit Node with a version of 0.10*.
	- Force install the 32 bit version of [`node-sqlite3`](https://github.com/mapbox/node-sqlite3) with `npm install sqlite3 --target_arch=ia32` and copy `\node_modules\sqlite3\lib\binding\Release\node-v11-win32-ia32` off to the side.
	- Force install the 64 bit version of [`node-sqlite3`](https://github.com/mapbox/node-sqlite3) with `npm install sqlite3 --target_arch=x64` and copy the 32 bit version, that you put off to the side, back into `\node_modules\sqlite3\lib\binding\Release\`.

3. Copy the contents from the root Ghost build into the configuration sub-directory `\Ghost`.
4. Ensure that there are no breaking changes to config.js and include config.js as included in this repo. There are two sets of changes required for this file:
	- Set port values need to be replaced with `process.env.PORT`.
	- Instead of promting the user to change config.js manually to include URL and email provider details, we can instruct Azure to display a dialog and change the file automatically. For this to work, config.js needs to have placeholder values.
		* `url: 'PlaceholderForUrl'`
    	*  
                mail: {
                    transport: 'SMTP',
                    options: {
                        service: 'PlaceholderForService',
                        auth: {
                            user: 'PlaceholderForUser', // mailgun username
                            pass: 'PlaceholderForPassword'  // mailgun password
                        }
                    }
                },
5. Include `manifest.xml`, `parameters.xml`, `TBEX.xml` and `ThirdPartyLicense.txt` into the root of your package folder.
6. ZIP all contents to match the file structure outlined below.
7. Create a SHA-1 key of the ZIP file - it will be required during submission of the package to Azure. Windows doesn't have a built-in tool, but the the tiny & portable [MD5 & SHA Checksum Utility](http://raylin.wordpress.com/downloads/md5-sha-1-checksum-utility/) will help.
8. [Test your package](http://www.iis.net/learn/develop/windows-web-application-gallery/package-an-application-for-the-windows-web-application-gallery) and submit.

#### Zip File Structure Example

<pre>
Ghost.zip  
|-- manifest.xml  
|-- parameters.xml
|-- TBEX.xml  
|-- ThirdPartyLicense.txt  
|-- Ghost  
|   |-- content  
|   |   `-- 
|   |-- core
|   |   `-- 
|   |-- node_modules
|   |   `-- 
|   |-- config.js
|   |-- iisnode.yml  
|   |-- web.config  
|   |-- index.js
|   |-- package.json
|   |-- rest of teh codez, filez, etc.
</pre>

## References

[Testing for Windows Azure App Gallery](http://blogs.msdn.com/b/azureappgallery/archive/2013/03/22/tips-for-a-successful-submission-to-windows-azure-app-gallery.aspx)  
[Testing for WebMatrix and Web PI](http://www.iis.net/learn/develop/windows-web-application-gallery/testing-a-web-application-zip-package-for-inclusion-with-the-web-application-gallery)  
[Submitting to Azure/Web App Gallery](http://blogs.msdn.com/b/azureappgallery/archive/2013/04/24/how-to-submit-an-application-to-web-app-gallery.aspx)  
