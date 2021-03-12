# "19041.867.1.8" = KB5000802
# "18362.1440.1.7" = KB5000808

$UpdateArray = @("19041.867.1.8", "18362.1440.1.7")

foreach ($UpdateVersion in $UpdateArray) {
    $SearchUpdates = dism /online /get-packages | findstr "Package_for" | findstr "$UpdateVersion"  
    if ($SearchUpdates) {
        $update = $SearchUpdates.split(":")[1].replace(" ", "")
        write-host ("Update result found: " + $update )
        dism /Online /Remove-Package /PackageName:$update /quiet /norestart
    } else {
        write-host ("Update " + $UpdateVersion + " not found.")
    }
}
exit 0