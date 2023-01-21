
$zwitch = 'K8S' 
$natnet = 'K8SNetNAT'
$cblock = '172.16.16'

If ($zwitch -in (Get-VMSwitch | Select-Object -ExpandProperty Name) -eq $FALSE) {
    "Creating Internal-only switch named $zwitch on Windows Hyper-V host..."
    New-VMSwitch -Name $zwitch -SwitchType internal
    New-NetIPAddress -IPAddress "$($cblock).1" -PrefixLength 24 -InterfaceAlias "vEthernet ($zwitch)"
    New-NetNat -Name $natnet -InternalIPInterfaceAddressPrefix "$($cblock).0/24"
}
else {
    "$zwitch for static IP configuration already exists; skipping"
}

If ("$($cblock).1" -in (Get-NetIPAddress | Select-Object -ExpandProperty IPAddress) -eq $FALSE) {
    "Registering new IP address $cblock.1 on Windows Hyper-V host..."
    New-NetIPAddress -IPAddress $($cblock).1 -PrefixLength 24 -InterfaceAlias "vEthernet ($zwitch)"
}
else {
    "$cblock.1 for static IP configuration already registered; skipping"
}

If ("$($cblock).0/24" -in (Get-NetNAT | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix) -eq $FALSE) {
    "Registering new NAT adapter for $($cblock).0/24 on Windows Hyper-V host..."
    New-NetNat -Name $natnet -InternalIPInterfaceAddressPrefix "$($cblock).0/24"
}
else {
    "$cblock.0/24 for static IP configuration already registered; skipping"
}