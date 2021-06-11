function Clear-Workflows {
 
    # Logic
    foreach ($item in Get-ChildItem . -Recurse) {
        foreach ($version in $item.Versions.GetVersions($true)) {
    
            $version.Editing.BeginEdit();
            $version.Fields["__Workflow"].Value = ""
            $version.Fields["__Workflow state"].Value = ""
            $version.Fields["__Default workflow"].Value = ""

            $version.Editing.EndEdit();

            Write-Host $version.ID  $version.Paths.FullPath
            $version;
     
    
        }   
    }

}

$locations = @("master:/sitecore/..", "/sitecore/media library/..")

foreach ($location in $locations) {
    Set-Location -Path $location
    $items =  Clear-Workflows 
}

