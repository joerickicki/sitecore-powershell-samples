
$FilterCriteria = @(
    @{Filter = "Equals"; Field = "_templatename"; Value = "Product"},
    @{Filter = "StartsWith"; Field = "_fullpath"; Value = "/sitecore/content/Home/Products/Product1" },
    @{Filter = "Equals"; Field = "Product Description"; Value = $null; Invert=$true}
)


Find-Item -Index "sitecore_master_index" -Criteria $FilterCriteria    
