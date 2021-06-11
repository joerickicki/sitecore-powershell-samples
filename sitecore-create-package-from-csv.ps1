#Upload the file on the Server in temporary folder
#It will create the folder if it is not found
$dataFolder = [Sitecore.Configuration.Settings]::DataFolder
$tempFolder = $dataFolder + "\temp\upload"
$filePath = Receive-File -Path $tempFolder -overwrite
 
if($filePath -eq "cancel"){
    exit
}
 
$resultSet =  Import-Csv $filePath
$rowsCount = ( $resultSet | Measure-Object ).Count;
 
if($rowsCount -le 0){
    #If there is no record in csv file then remove the file and exit
    Remove-Item $filePath
    exit
}
 
$package = New-Package "Release Package";
$package.Sources.Clear();

$package.Metadata.Author = "Author";
$package.Metadata.Publisher = "Publisher";
$package.Metadata.Version = "1.0";
$package.Metadata.Readme = 'Updating released sitecore items'
 
foreach ( $row in $resultSet ) {
    $currentItem = Get-Item -Path $row.ItemPath -ErrorAction SilentlyContinue
    if ($currentItem){

        $source = Get-Item $currentItem.Paths.FullPath | New-ItemSource -Name 'n/a' -InstallMode Overwrite
        $package.Sources.Add($source);

        $logInfo = "Item Added: " + $currentItem.Paths.FullPath;
        $logInfo
        Write-Log $logInfo
    }
    else {
        $logThis =  "Couldn't find: " + $row.ItemPath
        $logThis
        Write-Log $logThis
    }
}

Export-Package -Project $package -Path "$($package.Name)-$($package.Metadata.Version).zip" -Zip
Download-File "$SitecorePackageFolder\$($package.Name)-$($package.Metadata.Version).zip"

Remove-Item $filePath