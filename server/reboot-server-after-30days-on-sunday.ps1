if ((get-date).DayOfWeek -Eq "Sunday"){
    $wmi = Get-WmiObject -Class win32_OperatingSystem 
    if (($wmi.ConvertToDateTime($wmi.LocalDateTime) – $wmi.ConvertToDateTime($wmi.LastBootUpTime)).Days -ge 30){
        Restart-Computer -Force
    }
}
