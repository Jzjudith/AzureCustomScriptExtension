Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process
# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

Install-WindowsFeature -name Web-Server -IncludeManagementTools

Remove-Item C:\inetpub\wwwroot\iisstart.htm

Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $(" Hello  from " + $env:computername)