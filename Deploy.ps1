# OSDCloud ZTI Deploy
# Run via: powershell -ExecutionPolicy Bypass -Command "irm <URL> | iex"
# Designed for Shift+F10 at OOBE — fully zero-touch

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy Bypass -Scope Process -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

#Force Install Nuget
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootstrap -Confirm:$false

# Install OSD module
Install-Module OSD -Force -SkipPublisherCheck
Import-Module OSD -Force

# Begin transcript
$logDir = 'C:\OSDCloud\Logs'
New-Item -Path $logDir -ItemType Directory -Force | Out-Null
Start-Transcript -Path "$logDir\OSDCloud.log" -Append -Force

$VerbosePreference = 'Continue'

# Start deployment — ZTI, no prompts
Start-OSDCloud `
    -OSName 'Windows 11 Enterprise' `
    -OSLanguage 'en-gb' `
    -ZTI `
    -DriverPackHP

# Queue post-install hook (edit URL to point at your post-install script)
$setupComplete = 'C:\Windows\Setup\Scripts\SetupComplete.cmd'
New-Item -Path (Split-Path $setupComplete) -ItemType Directory -Force | Out-Null
# Uncomment and fill in URL when you're ready to add post-install steps:
# "powershell -ExecutionPolicy Bypass -Command ""irm https://YOUR_URL/postinstall.ps1 | iex""" | Set-Content $setupComplete

Stop-Transcript

