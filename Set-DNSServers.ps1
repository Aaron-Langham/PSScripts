# Choose whatever Primary and Secondary DNS Servers you want. Some common
# DNS Services are listed below, but you can use whatever you want.
#
# Level3                    209.244.0.3 and 209.244.0.4
# Verisign                  64.6.64.6 and 64.6.65.6
# Google                    8.8.8.8 and 8.8.4.4
# Quad9                     9.9.9.9 and 149.112.112.112
# DNS.WATCH                 84.200.69.80 and 84.200.70.40
# Comodo Secure DNS         8.26.56.26 and 8.20.247.20
# OpenDNS Home              208.67.222.222 and 208.67.220.220
# Norton ConnectSafe        199.85.126.10 and 199.85.127.10
# Cloudflare                1.1.1.1 and 1.0.0.1
# AdGuard                   94.140.14.14 and 94.140.15.15
#

#http://powershell-guru.com/powershell-tip-63-check-if-a-computer-is-member-of-a-domain-or-workgroup/
if ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain){
    write-host "Domain member, we better not update the DNS!!"
    exit
}

$PrimaryDNS = '208.67.222.222'
$SecondaryDNS = '208.67.220.220'

$DNSServers = $PrimaryDNS,$SecondaryDNS

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object{$_.IPEnabled -eq "TRUE"}

function get-return-status {
        Param ($code)
        If ($code -eq 0) {
                return "Success."
  } elseif ($code -eq 1) {
                return "Success, but Restart Required."
  } else {
                return "Error with Code $($code)!"
  }
}

Foreach($NIC in $NICs) {
  ""
  "-------"
  "Attempting to modify DNS Servers for the following NIC:"
  $NIC
  $returnValue = $NIC.SetDNSServerSearchOrder($DNSServers).ReturnValue
  $response = get-return-status($returnValue)
  Write-Host "Setting DNS Servers to ${$NICs}...$($response)"
  $returnValue = $NIC.SetDynamicDNSRegistration("True").ReturnValue
  $response = get-return-status($returnValue)
  Write-Host "Setting Dynamic DNS Registration to True...$($response)"
}
