# Ghost - Azure Gallery App

This package contains configuration files that are required to submit Ghost as a package to the [Azure App Gallery](http://www.microsoft.com/web/gallery/developer.aspx).

The Azure package for Ghost should be:

- Configured optimally for Azure.
- Secure out-of-the-box.

## Getting Started

Submission to the Azure App Gallery requires _all_ of the Ghost module dependencies. Prior to getting started, please review the [Ghost installation instructions](https://github.com/TryGhost/Ghost/blob/master/CONTRIBUTING.md#installation--setup-instructions) to setup a developer environment, e.g. Install Node.js.

### Publish Instructions

Note that this package is not only intended to target Azure, but all Windows PCs in general - it has to handle 32 and 64-bit Windows architecture.  

**NB:** It is required that you build this package with a 64-bit Windows machine.

#### Creating a Web App Gallery Package

A Windows Web App Package has essentially only two major components: The Ghost folder after `npm install` has been run and a set of three configuration files.
    
1. Download the official *.zip release of Ghost from GitHub, [https://github.com/TryGhost/Ghost/releases](https://github.com/TryGhost/Ghost/releases "https://github.com/TryGhost/Ghost/releases"). The official releases are recommended as it includes the default Casper theme and has been compiled with `grunt --production`. 
2. Open Powershell and execute the `Package.ps1` script, `.\Package.ps1 -GhostZip .\ghost-0.5.1.zip`. The Powershell script will:
    - Extract the release to temporary directory.
    - Install the module dependencies (`npm install`).
    - Install both x32 and x64 bit versions of SQLite3.
    - Copies the Azure configuration files from this repository.
    - Copies the package meta-data.
    - Finally creates a zip of the result and generates a SHA-1 hash that required to submit the package to Azure. 


#### Testing a Web App Gallery Package

Deploy the package you have just created to Azure using Web Deploy. If you do not have a subscription to Azure, you can begin a trial. Remeber, if you have an [MSDN subscription](http://www.visualstudio.com/en-us/products/msdn-subscriptions-vs), one of the many benefits is monthly credit to spend on Azure. 

1. Open your Azure Portal and Quick Create an Web Site, New > Compute > Web Site > Quick Create.
2. Once created, open the dashboard for the Web Site and download your Publishing Profile. 
3. Take note of your the Web Site name, e.g. http://**website-name**.azurewebsites.net/ 
4. Copy the `*.PublishSettings` to the local directory. 
5. Open the `setparameters.xml` file and configure to your Azure Web Site. For example:
        - Replace `ReplaceWithAzureWebsiteName` with the name of the Azure Web Site.
        - Select one of the email providers. 
        - Enter credentials for your email provider. If using Gmail, recommend creating a [App Specific Password for your Google Account](https://support.google.com/accounts/answer/185833).
6. Open Powershell and execute the `Deploy.ps1` script, 
        `.\Deploy.ps1 -SourcePublishSettings .\your-azure-website.PublishSettings -Package .\azure-ghost-0.5.1.zip -Parameters .\setparameters.xml -Launch`.
7. Verify that it has deployed and Ghost performs as expected.

#### Submit the update to Azure Gallery

As this is an update to the existing package on Azure, you need to reach out to the previous submitters of the package to ask them to submit an update on your behalf or ask for co-ownership.

## References

[Testing for Windows Azure App Gallery](http://blogs.msdn.com/b/azureappgallery/archive/2013/03/22/tips-for-a-successful-submission-to-windows-azure-app-gallery.aspx)  
[Testing for WebMatrix and Web PI](http://www.iis.net/learn/develop/windows-web-application-gallery/testing-a-web-application-zip-package-for-inclusion-with-the-web-application-gallery)  
[Submitting to Azure/Web App Gallery](http://blogs.msdn.com/b/azureappgallery/archive/2013/04/24/how-to-submit-an-application-to-web-app-gallery.aspx)  
