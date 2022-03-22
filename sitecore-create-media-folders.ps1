
$mediaFolderTemplate = "{11111111-1111-1111-11111-111111111111}"

function CreateMediaFolderItem($medialFolderItemPath)
{
	$mediaItem = Get-Item -Path master: -Query $medialFolderItemPath  -ErrorAction SilentlyContinue
	
	if ($mediaItem -eq $null) {
		$pathElements = $medialFolderItemPath.Split("/")
		
		if ($pathElements.Count - 2 -lt 0) {return $mediaItem}
		
		$mediaParentItem = CreateMediaFolderItem([system.String]::Join("/", $pathElements[0..($pathElements.Count-2)]))

		if ($mediaParentItem -ne $null){
			$mediaItem = New-Item $medialFolderItemPath -ItemType "/sitecore/templates/System/Media/Media folder"
		}
	}

    return $mediaItem
}

$familyItems = Get-ChildItem -Path ("..")
foreach ($familyItem in $familyItems) {

    CreateMediaFolderItem("/sitecore/media library/../")
    CreateMediaFolderItem("/sitecore/media library/../")
}

