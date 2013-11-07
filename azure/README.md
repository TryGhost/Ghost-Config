# Ghost - Azure Gallery App

This package contains configuration files that are required to submit Ghost as a package to the [Azure App Gallery](http://www.microsoft.com/web/gallery/developer.aspx).

## Getting Started

Submission to the Azure App Gallery requires _all_ of the Ghost module dependencies - this includes `node_modules`.  Prior to getting started, please review the [Ghost installation instructions](https://github.com/TryGhost/Ghost/blob/master/CONTRIBUTING.md#installation--setup-instructions).  Once you have a clone of Ghost and all the pre-requisites installed, you are ready to get started.


### Publish Instructions

Note that this package is not only intended to target Azure, but all Windows PCs in general - it has to handle 32 and 64-bit Windows architecture.  It is recommended that you build this package with a Windows machine.

#### Getting Ghost Ready

First, checkout the Ghost tag you wish to target for the Azure Gallery publish.

1. Install Grunt `npm install -g grunt-cli`
2. Install Ghost dependencies `npm install`

Things get a little goofy here as we must have SQLite bindings for both the 32 and 64-bit Windows architecture.

3. Force install the 32 bit version of [`node-sqlite3`](https://github.com/mapbox/node-sqlite3) with `npm install sqlite3 --target_arch=ia32` and copy `\node_modules\sqlite3\lib\binding\Release\node-v11-win32-ia32` off to the side.
4. Force install the 64 bit version of [`node-sqlite3`](https://github.com/mapbox/node-sqlite3) with `npm install sqlite3 --target_arch=x64` and copy the 32 bit version, that you put off to the side, back into `\node_modules\sqlite3\lib\binding\Release\`.

Finish off the build with a couple of `grunt` tasks.

4. Run `grunt init`
5. Run `grunt prod`

#### Getting the Ghost Azure Package Ready

1. Copy the contents from the root Ghost build into the configuration sub-directory `\Ghost`.  Feel free to copy everything as the end user may want to put it in `git`.
2. Zip up everything and it should look like example below.
3. Submit

#### Zip File Structure Example

<pre>
GhostPackage.zip  
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