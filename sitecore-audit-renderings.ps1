$device = Get-LayoutDevice -Default
$Results = @(); 

$criteria = @(
  #@{ Filter = "Equals"; Field = "_templatename"; Value = "Site Page"; }, 
  #@{ Filter = "StartsWith"; Field = "_fullpath"; Value = "/sitecore/content/MySite/Home/" }
  @{ Filter = "DescendantOf"; Value = (Get-Item "master:/sitecore/content/Mysite/Home/"); }
)

$props = @{
    Index = "sitecore_master_index"
    Criteria = $criteria
}

$contentItems = Find-Item @props

foreach($contentItem in $contentItems){

    $page = Get-Item master: -ID $contentItem.ItemId
    Write-Host $page.Name   

    $renderings = Get-Rendering -Item $page -Device $device -FinalLayout
 
    foreach($rendering in $renderings){
 
        if($rendering.ItemID -ne $null)
        {
            $renderingItem = Get-Item master: -ID $rendering.ItemID
            if($renderingItem -ne $null)
            {
                $Properties = @{
                    RenderingItemName = $renderingItem.Name
                    RenderingItemID = $renderingItem.ID
                    RenderingItemPath = $renderingItem.Paths.Path
                    UsedOnPage = $page.Name
                    UsedOnPageID = $page.ID
                    UsedOnPagePath = $page.Paths.Path
                }
 
                $Results += New-Object psobject -Property $Properties
            }
        }
 
    }
}
 
$results | Select-Object RenderingItemName,RenderingItemID,RenderingItemPath,UsedOnPage,UsedOnPageID,UsedOnPagePath | ConvertTo-Csv -notypeinformation | Out-String | Out-Download -Name env-settings.csv
