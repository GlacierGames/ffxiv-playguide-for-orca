# Device Manager
# 0     Other Devices
# 1     Error Devices (Yellow Bang)
# 2     Camera Number

function GetDevStatus {
    $Device_other = @()
    $Device_yellowbang = @()
    $CameraNum=0
    $All_List = Get-CimInstance -Class Win32_PNPEntity
    foreach ($i in $All_List) {
        if ($Null -ne $i.Name  -and $Null -eq $i.PNPClass) {
            $Device_other += ($i.Name)
        }
        if ($i.Status -eq "Error") {
            $Device_yellowbang += ($i.Name)
        }
        if ($i.PNPClass -eq "Camera"){
            $CameraNum+=1
        }
    }
    return $Device_other, $Device_yellowbang,$CameraNum
}

function CatchChange {
    Write-Host("************Listening Device Change************")
    $device=Get-CimInstance -Class Win32_PNPEntity
    $device_num=$device.Length
    while ($device_num -eq((Get-CimInstance -Class Win32_PNPEntity).Length)){

    }
    if ($device_num -gt((Get-CimInstance -Class Win32_PNPEntity).Length)){
        Write-Host("Remove Device")
    }
    else{
        Write-Host("Add Device")
    }
    $device_Change=Get-CimInstance -Class Win32_PNPEntity
    $device_Compare=Compare-Object $device $device_Change
    $time=Get-Date
    Write-Host($time)
    $device_Compare.InputObject | % {Write-Host $_.Name $_.DeviceID}
}

# CatchChange
$a = GetDevStatus

if ($Null -eq $a) {
    Write-Host("No Error")
}
else {
    Write-Host("************Other Devices************")
    $a[0]
    Write-Host("")
    Write-Host("************YellowBang Devices************")
    $a[1]
    Write-Host("")
    Write-Host("************Camera Num************")
    $a[2]
}
while ($True){
    CatchChange
}