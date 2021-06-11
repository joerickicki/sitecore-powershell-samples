function DownloadXml ([xml]$xml)
{
    $StringWriter = New-Object System.IO.StringWriter;
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter;
    $XmlWriter.Formatting = "indented";
    $xml.WriteTo($XmlWriter);
    $XmlWriter.Flush();
    $StringWriter.Flush();
    $StringWriter.ToString() | Out-Download -Name crud.xml
}

$xmlDoc = [My.Xml.Class]::GetCrud("{27F62F2B-D903-42FC-A593-649B4639721F}")
DownloadXml $xmlDoc
