#clear cache method

$results = @();
$envArray = @();

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$envArray += [PSCustomObject]@{
    ID = '0'
    Name = 'local'
    Url = '..'
    Username = ''
    Password = ''
}

$envArray += [PSCustomObject]@{
    ID = '1'
    Name = 'QA'
    Url = '..'
    Username = ''
    Password = ''
}

$cacheArray = @()

$cacheArray += [PSCustomObject]@{
    ID = '0'
    Name = 'service 1'
    Url = '..'
}

$cacheArray += [PSCustomObject]@{
    ID = '1'
    Name = 'service 2'
    Notes = ''
    Url = '..'
}
 
$envs = [ordered]@{}

foreach($env in $envArray) {
   $envs[$env.Name] = $env.ID
}

$caches = [ordered]@{}

foreach($cache in $cacheArray) {
  $caches[$cache.Name] = $cache.ID
}

$currentUser = [Sitecore.Context]::User

$dialogParams = @{
    Title = "Dialog title"
    Description = "Description under title"
    OkButtonName = "Execute"
    CancelButtonName = "Close"
    ShowHints = $true
    Parameters = @(
        @{
            Name = "selectedEnvironmentID"
            Title = "Select Environment"
            Editor="combobox"
            Options=$envs;
            Tooltip = "Select an environment from the list below"
        }
        @{
            Name = "selectedCacheID"
            Title = "Select Cache"
            Editor="combobox"
            Options=$caches;
            Tooltip = "Select a service data cache from the list below"
        }
        @{
            Name = "userName"
            Title = "Username"
            #Value = $currentUser.Name
            Tooltip = "*leave empty for unsecured links"
        }
        @{
            Name = "passWord"
            Editor="Password"
            Title = "Password"
            Tooltip = "*leave empty for unsecured links"
        }
    )
}
 
$dialogResult = Read-Variable @dialogParams

if($result -eq "cancel"){
    exit
}
 
$selectedEnvironment = $envArray | Where-Object {$_.ID -eq $selectedEnvironmentID}
$selectedCache = $cacheArray | Where-Object {$_.ID -eq $selectedCacheID}

if($selectedEnvironment -eq $null -or $selectedCache -eq $null) {
    exit
}

$pageResponse = $null
$url = $selectedEnvironment.Url + $selectedCache.Url

try {
    if($userName -eq '' -or $passWord -eq '') {
        $pageResponse = Invoke-WebRequest -UseBasicParsing -Uri $url
    }
    else {
        $secpasswd = ConvertTo-SecureString $passWord -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($userName, $secpasswd)
        
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
        
        $pageResponse = Invoke-WebRequest -UseBasicParsing -Uri $url -Credential $credential 
    }
    
    Write-Host $("Attempting cache clear for" + $url)
    $responseCode = $pageResponse.StatusCode

    if ($responseCode -eq 200){
        Write-Host "Cache cleared successfully."
    }
    else {
        Write-Host $("Cache cleared failed with response code: " + $responseCode)
        Write-Host $pageResponse.Content
    }
}
catch {
    Write-Host $("Cache cleared failed with exception: " +  $_.Exception.Message)
}

Show-Result -Text

 