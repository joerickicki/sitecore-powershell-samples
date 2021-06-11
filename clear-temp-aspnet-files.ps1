if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

net stop w3svc
Get-ChildItem "C:\Windows\Microsoft.NET\Framework*\v*\Temporary ASP.NET Files" -Recurse | Remove-Item -Recurse -Force
net start w3svc