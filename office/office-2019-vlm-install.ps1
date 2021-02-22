# Install Office 2019 VLM license edition. Download your own copy of the VLM Setup.exe.
New-Item -ItemType directory -Path "C:\OfficeSetup" -Force | Out-Null
Invoke-WebRequest -Uri https://example.com/setup.exe -OutFile C:\OfficeSetup\setup.exe
Set-Location -Path "C:\OfficeSetup" | Out-Null
New-Item -ItemType file -Path .\configuration64.xml -Force | Out-Null
Add-Content -Path .\configuration64.xml -Value '<Configuration>'
Add-Content -Path .\configuration64.xml -Value '  <Info Description="Office Standard 2019 (64-bit)" />'
Add-Content -Path .\configuration64.xml -Value '  <Add OfficeClientEdition="64" Channel="PerpetualVL2019" SourcePath="C:\OfficeSetup">'
Add-Content -Path .\configuration64.xml -Value '    <Product ID="Standard2019Volume" PIDKEY="XXXXX-XXXXX-XXXXX-XXXXX-XXXXX">'
Add-Content -Path .\configuration64.xml -Value '      <Language ID="en-us" />'
Add-Content -Path .\configuration64.xml -Value '    </Product>'
Add-Content -Path .\configuration64.xml -Value '  </Add>'
Add-Content -Path .\configuration64.xml -Value '  <RemoveMSI />'
Add-Content -Path .\configuration64.xml -Value '  <Display Level="Full" AcceptEULA="TRUE" />'
Add-Content -Path .\configuration64.xml -Value '</Configuration>'
$hash = Get-FileHash .\setup.exe
$signerhash = Get-AuthenticodeSignature .\setup.exe
if ($hash.Hash -eq "4F5C5CBCBF63115D0FA4F79988F80B9753B1C43D5A2B2C1DD1A6597EA9038E6E" -And $signerhash.Status -eq "Valid")
{
    echo "Downloading Office"
    .\setup.exe /download C:\OfficeSetup\configuration64.xml
    echo "Installing"
    .\setup.exe /configure C:\OfficeSetup\configuration64.xml
}