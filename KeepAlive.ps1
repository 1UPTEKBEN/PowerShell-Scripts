function Format-TimeSpan {
    param (
        [System.TimeSpan]$TimeSpan
    )
    "{0:D2}:{1:D2}:{2:D2}" -f $TimeSpan.Hours, $TimeSpan.Minutes, $TimeSpan.Seconds
}

$startTime = Get-Date

# Allocate and initialize memory
$PowerRequest = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(64)
$byteArray = New-Object byte[] (64)
[System.Runtime.InteropServices.Marshal]::Copy($byteArray, 0, $PowerRequest, 64)

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class PowerManagement {
    [DllImport("kernel32.dll")]
    public static extern IntPtr SetThreadExecutionState(IntPtr esFlags);
}
"@

$ES_CONTINUOUS = 0x80000000
$ES_SYSTEM_REQUIRED = 0x00000001
$ES_DISPLAY_REQUIRED = 0x00000002
$ES_AWAYMODE_REQUIRED = 0x00000040

try {
    while ($true) {
        [PowerManagement]::SetThreadExecutionState($ES_CONTINUOUS -bor $ES_SYSTEM_REQUIRED -bor $ES_DISPLAY_REQUIRED -bor $ES_AWAYMODE_REQUIRED) | Out-Null

        $elapsedTime = (Get-Date) - $startTime
        $formattedTime = Format-TimeSpan -TimeSpan $elapsedTime

        Write-Host "Script has been running for $formattedTime"

        Start-Sleep -Seconds 1
    }
} finally {
    # Free the allocated memory
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($PowerRequest)
}
