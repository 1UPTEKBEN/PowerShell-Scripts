$outputFile = "C:\DomainLoginData.csv"

function Get-LoginEvents {
    param (
        [string]$ComputerName
    )
    try {
        Write-Host "Processing $ComputerName..."
        
        $events = Invoke-Command -ComputerName $ComputerName -ScriptBlock {

            Get-EventLog -LogName Security | Where-Object {$_.EventID -eq 4624} | 
            Select-Object @{Name="TimeCreated";Expression={$_.TimeGenerated}}, 
                          @{Name="User";Expression={$_.ReplacementStrings[5]}}, 
                          @{Name="LogonType";Expression={$_.ReplacementStrings[8]}}
        }

        $logonData = foreach ($event in $events) {
            [PSCustomObject]@{
                ComputerName   = $ComputerName
                TimeGenerated  = $event.TimeCreated
                User           = $event.User
                LogonType      = $event.LogonType
            }
        }

        return $logonData
    } catch {
        Write-Warning ("Failed to process " + $ComputerName + ": " + $_.Exception.Message)
        return $null
    }
}

$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

$allLoginData = @()

foreach ($computer in $computers) {
    $loginData = Get-LoginEvents -ComputerName $computer
    if ($loginData) {
        $allLoginData += $loginData
    }
}

if ($allLoginData.Count -gt 0) {
    $allLoginData | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
    Write-Host "Data exported to $outputFile"
} else {
    Write-Warning "No data to export."
}
