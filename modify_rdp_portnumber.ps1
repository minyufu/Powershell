function Pause(){
[System.Console]::Write('按任意見繼續...')
[void][System.Console]::ReadKey(1)
}
#更改預設RDP端口號並添加防火牆規則
Write-Output "-----目前RDP使用端口號-----"
$Now_RDP_PortNumber = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal*Server\WinStations\RDP-TCP\" -Name PortNumber | Select-Object PortNumber
Write-Output "PortNumber: $Now_RDP_PortNumber"
#powershell 輸入需要修改的端口號:
$New_Rdp_PortNumber = Read-Host -Prompt '輸入新的RDP端口號'
#設定新的端口號
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal*Server\WinStations\RDP-TCP\" -Name PortNumber -Value $New_Rdp_PortNumber
#加入TCP防火牆規則
New-NetFirewallRule -DisplayName "遠程桌面(TCP-In) $New_Rdp_PortNumber" -Direction Inbound -Protocol TCP -Profile Any -LocalPort $New_Rdp_PortNumber -Action allow
Write-Output "遠程桌面(TCP-In)防火牆規則添加完成"
#加入UDP防火牆規則
New-NetFirewallRule -DisplayName "遠程桌面(UDP-In) $New_Rdp_PortNumber" -Direction Inbound -Protocol TCP -Profile Any -LocalPort $New_Rdp_PortNumber -Action allow
Write-Output "遠程桌面(UDP-In)防火牆規則添加完成"
$Now_RDP_PortNumber = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal*Server\WinStations\RDP-TCP\" -Name PortNumber | Select-Object PortNumber
Write-Output "Now Use RDP Port Number: $Now_RDP_PortNumber"
Pause