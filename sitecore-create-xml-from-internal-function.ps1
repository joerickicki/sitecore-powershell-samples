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

$xmlDoc = [My.Xml.Class]::GetXmlFromSitecoreInternalFunction("{111111-1111-1111-1111-111111111112}")
DownloadXml $xmlDoc
