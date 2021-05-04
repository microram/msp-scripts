## Webroot Extension Removal for Chrome and Firefox

$FailureCount = 0
## Remove Webroot extension from all Chrome profiles
$WebrootChromeExtension = "kjeghcllfecehndceplomkocgfbklffd"
Get-ChildItem -Path "C:\Users" | ForEach-Object {
    $ProfileFolder = "$($_.FullName)\AppData\Local\Google\Chrome\"
     if (Test-Path -Path $ProfileFolder) {
        Get-ChildItem -Path $ProfileFolder -Recurse -Filter $WebrootChromeExtension | ForEach-Object {
            if ($_.Name -eq $WebrootChromeExtension) {
                Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $_.FullName) { 
                    Write-Host "Error removing:$($_.FullName)"
                    $FailureCount += 1
                } else {
                    Write-Host "Successfully removed:$($_.FullName)"
                }
            }
        }
    }
}

## Remove Webroot extension from all Firefox profiles
$WebrootFireFoxExtension = "webrootsecure@webroot.com.xpi"
Get-ChildItem -Path "C:\Users" | ForEach-Object {
    $ProfileFolder = "$($_.FullName)\AppData\Roaming\Mozilla\Firefox\Profiles\"
     if (Test-Path -Path $ProfileFolder) {
        Get-ChildItem -Path $ProfileFolder -Recurse -Filter "*.xpi" | ForEach-Object {
            if ($_.Name -eq $WebrootFireFoxExtension) {
                Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                if (Test-Path $_.FullName) { 
                    Write-Host "Error removing:$($_.FullName)"
                    $FailureCount += 1
                } else {
                    Write-Host "Successfully removed:$($_.FullName)"
                }
            }
        }
    }
}
if ($FailureCount) { Write-Host "$($FailureCount) error(s)" }
exit $FailureCount