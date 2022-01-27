
$FilterCriteria = @(
    @{Filter = "Equals"; Field = "_templatename"; Value = "Product Part"},
    @{Filter = "StartsWith"; Field = "_fullpath"; Value = "/sitecore/content/Home/Products/Fusible Switches and Panels" },
    @{Filter = "Equals"; Field = "Banner Heading"; Value = $null; Invert=$true}
)


Find-Item -Index "sitecore_master_index" -Criteria $FilterCriteria    