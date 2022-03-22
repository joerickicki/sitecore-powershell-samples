$templateIds = @(
    "{11111111-1111-1111-1111-1111111112}"
)

@(Get-ChildItem -Path master:/sitecore/.. -Recurse) |
    Where-Object { $templateIds -contains $_.TemplateId } |
    Select-Object -Property Name, TemplateId |
    Measure-Object
