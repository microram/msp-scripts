# Dental - Aligntech Mycadent Invisialign Port Test
# Verify all listed domains & ports are accessible  
# https://ip-ranges.amazonaws.com/ip-ranges.json


$array = @(
    ("Mycadent.com", 443),
    ("Mycadent.com", 80),
    ("Myaligntech.com", 443),
    ("Myaligntech.com", 80),
    ("Export.mycadent.com", 443),
    ("Export.mycadent.com", 80),
    ("Cboserver.mycadent.com",443),
    ("Cboserver.mycadent.com",80),
    ("Matstore.invisalign.com",443),
    ("Matstore.invisalign.com",80),
    ("Matstore2.invisalign.com",443),
    ("Matstore2.invisalign.com",80),
    ("Matstore3.invisalign.com",443),
    ("Matstore3.invisalign.com",80),
    ("Matstore4.invisalign.com",443),
    ("Matstore4.invisalign.com",80),
    ("Matstoresg.invisalign.com",443),
    ("Matstoresg.invisalign.com",80),
    ("Matstorechn.invisalign.com.cn",443),
    ("Matstorechn.invisalign.com.cn",80),
    ("ec2-reachability.amazonaws.com",443),
    ("ec2-reachability.amazonaws.com",80),
    ("alignapi.aligntech.com",443),
    ("alignapi.aligntech.com",80),
    ("www.google.com",443),
    ("www.google.com",80),
    ("www.microsoft.com",443),
    ("www.microsoft.com",80),
    ("www.yahoo.com",443),
    ("www.yahoo.com",80),
    ("storage.cloud.aligntech.com",443),
    ("cloud.myitero.com",443),
    ("bff.cloud.myitero.com",443),
    ("speedtest.net",443),
    ("speedtest.net",80),
    ("fast.com",443),
    ("fast.com",80),
    ("speedtest.tele2.net",80)
    )

    $ErrorActionPreference= 'silentlycontinue'

foreach ($element in $array)
{
    $ipaddress = $element[0]
    $port = $element[1]
    $connection = New-Object System.Net.Sockets.TcpClient($ipaddress, $port)
    if ($connection.Connected) {
        Write-Host "Success on $($ipaddress):$($port)"
    }
    else {
        Write-Host -BackgroundColor red "*Failed on $($ipaddress):$($port)"
    }
    $connection = $null
}