# https://support.umbrella.com/hc/en-us/articles/360035939731-Important-firewall-changes-may-be-required-for-Umbrella-and-OpenDNS-users
# Returns 146.112.61.108 when using OpenDNS on Success. 146.112.255.152-159 or 67.215.92.210 on Failure.

Import-Module $env:SyncroModule
$ip = (Resolve-DnsName internetbadguys.com -type A | Select-Object -Property IPAddress)
if (( ([version]'146.112.255.152') -lt ([version]$ip.IPAddress) -and ([version]$ip.IPAddress) -lt ([version]'146.112.255.159') ) -or ($ip -eq '67.215.92.210') )
{
    Rmm-Alert -Category 'DNS Filtering' -Body 'Failed OpenDNS filtering audit'
}