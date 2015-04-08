configuration Sample_cWebsite_NewWebsite
{
    param
    (
        # Target nodes to apply the configuration
        [string[]]$NodeName = 'localhost',

        # Name of the website to create
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$WebSiteName,

        # Source Path for Website content
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$SourcePath,

        # Destination path for Website content
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$DestinationPath
    )

    # Import the module that defines custom resources
    Import-DscResource -Module cWebAdministration

    Node $NodeName
    {
        # Install the IIS role
        WindowsFeature IIS
        {
            Ensure          = "Present"
            Name            = "Web-Server"
        }

        # Install the ASP .NET 4.5 role
        WindowsFeature AspNet45
        {
            Ensure          = "Present"
            Name            = "Web-Asp-Net45"
        }

        # Stop the default website
        cWebsite DefaultSite 
        {
            Ensure          = "Present"
            Name            = "Default Web Site"
            State           = "Stopped"
            PhysicalPath    = "C:\inetpub\wwwroot"
            DependsOn       = "[WindowsFeature]IIS"
        }

        # Copy the website content
        File WebContent
        {
            Ensure          = "Present"
            SourcePath      = $SourcePath
            DestinationPath = $DestinationPath
            Recurse         = $true
            Type            = "Directory"
            DependsOn       = "[WindowsFeature]AspNet45"
        }       

        # Create the new AppPool
        cAppPool NewAppPool
        {
            Name = $AppPoolName
            Ensure = "Present"
            autoStart = "true"  
            managedRuntimeVersion = "v4.0"
            managedPipelineMode = "Integrated"
            startMode = "AlwaysRunning"
            identityType = "ApplicationPoolIdentity"
            restartSchedule = @("18:30:00","05:00:00")
        }
        
        # Create the new Website
        cWebsite NewWebsite
        {
            Ensure          = "Present"
            Name            = $WebSiteName
            State           = "Started"
            PhysicalPath    = $DestinationPath
            BindingInfo  = @(
                PSHOrg_cWebBindingInformation 
                {
                    Protocol = 'HTTP'
                    Port     = 80
                    HostName = '*'
                }
                PSHOrg_cWebBindingInformation 
                {
                    Protocol = 'HTTPS'
                    Port     = 433
                    HostName = '*'
                }
            )
            webConfigProp = @(
                PSHOrg_cWebConfigProp
                {
                    Filter = 'system.webServer/urlCompression'
                    PSPath = 'MACHINE/WEBROOT/APPHOST/DemoSite'
                    Name = 'doStaticCompression'
                    Value = 'true'
                }
                PSHOrg_cWebConfigProp
                {
                    Filter = 'system.webServer/security/access'
                    PSPath = 'MACHINE/WEBROOT/APPHOST'
                    Location = 'DemoSite'
                    Name = 'sslFlags'
                    Value = 'Ssl,SslNegotiateCert,SslRequireCert'
                }
                PSHOrg_cWebConfigProp
                {
                    Filter = 'system.webServer/cgi'
                    PSPath = 'MACHINE/WEBROOT/APPHOST'
                    Location = 'DemoSite'
                    Name = 'timeout'
                    Value = '00:20:00'
                }
                PSHOrg_cWebConfigProp
                {
                    Filter = 'system.web/customErrors'
                    PSPath = 'MACHINE/WEBROOT/APPHOST/DemoSite'
                    Name = 'mode'
                    Value = 'Off'
                }
                PSHOrg_cWebConfigProp
                {
                    Filter = 'system.net/mailSettings/smtp/network'
                    PSPath = 'MACHINE/WEBROOT/APPHOST/DemoSite'
                    Name = 'host'
                    Value = 'TestSMTPHost'
                }
            )
            ApplicationPool = $AppPoolName
            DependsOn = @("[WindowsFeature]IIS","[File]WebContent","[cAppPool]NewAppPool")           
        }
        

    }
}


