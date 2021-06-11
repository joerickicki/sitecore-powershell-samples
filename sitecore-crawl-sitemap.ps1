#this grabs the sitemap and does a basic run through the urls

$results = @();

$sitemapUrl = "https://../sitemap.xml"
$nofollow = $true

$username = ''
$password = ''

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

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $secpasswd)

$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

[xml]$sitemap = Invoke-WebRequest -UseBasicParsing -Uri $sitemapUrl -Credential $credential |select -expand content
#[xml]$sitemap = Invoke-WebRequest -UseBasicParsing -Uri $sitemapUrl |select -expand content

$sitemap.urlset.url | Foreach-Object {
 
    try {
        $url = $_.loc
        $url = $url.replace("..","..") 
        $pageResponse = Invoke-WebRequest -UseBasicParsing -Uri $url -Credential $credential
        #$pageResponse = Invoke-WebRequest -UseBasicParsing -Uri $url
        $responseCode = $pageResponse.StatusCode
        $content = ""
        if ($responseCode -ne 200){
            $content = $pageResponse.Content
        }
        
        $properties = @{
              Url =  $url
              Response = $responseCode
              Content = $content
         }
    
         $results += New-Object psobject -Property $properties
    }
    catch {
    
          $properties = @{
              Url =  $url
              Response = 0
              Content = $_.Exception.Message
         }
              
               $results += New-Object psobject -Property $properties
         
    }
    
    Start-Sleep -m 200
}

 
$results | Select-Object Url,Response,Content | ConvertTo-Csv -notypeinformation | Out-String | Out-Download -Name env-settings.csv