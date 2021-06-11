$templateIds = @(
    "{89A08B70-2079-4E4D-8953-47C2E0A60221}"
)

@(Get-ChildItem -Path master:/sitecore/.. -Recurse) |
    Where-Object { $templateIds -contains $_.TemplateId } |
    Select-Object -Property Name, TemplateId |
    Measure-Object