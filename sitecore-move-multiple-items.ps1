 $dialogParams = @{
    Title = "Move multiple media items"
    Description = "Be careful doing this"
    OkButtonName = "Execute"
    CancelButtonName = "Close"
    ShowHints = $true
    Parameters = @(

        @{
            Name = "treeListSelectorTargets"
            Title = "Select Items to Move"
            Editor = "treelist"
            Source = "DataSource=/sitecore/media library&DatabaseName=master"
            Tooltip = "Select Items to Move"
        }

         @{
            Name = "treeListSelectorDestination"
            Title = "Select Destination Parent Item"
            Editor = "treelist"
            Source = "DataSource=/sitecore/media library&DatabaseName=master"
            Tooltip = "Select Destination Parent Item"
        }
    )
}

$dialogResult = Read-Variable @dialogParams 

foreach ($treeListTarget in $treeListSelectorTargets){
    try {
        Move-Item -Path $treeListTarget.Paths.Path -Destination $treeListSelectorDestination.Paths.Path
        Write-Host "Moved $treeListTarget.Paths.Path to $treeListSelectorDestination.Paths.Path"
    }
    catch {
        Write-Host "Error moving $treeListTarget.Paths.Path to $treeListSelectorDestination.Paths.Path"
    }
}