Import-Module ActiveDirectory

$outputFile = "C:\Temp\DomainComputersStatus.csv"

$computers = Get-ADComputer -Filter * -Property Name | Select-Object -ExpandProperty Name

$results = @()

foreach ($computer in $computers) {
    Write-Host "Pinging $computer..." -ForegroundColor Yellow

    $pingResult = Test-Connection -ComputerName $computer -Count 1 -Quiet

    $status = if ($pingResult) { "ALIVE" } else { "DEAD" }

    $results += [PSCustomObject]@{
        ComputerName = $computer
        Status       = $status
    }
}

$results | Export-Csv -Path $outputFile -NoTypeInformation -Force

Write-Host "Results exported to $outputFile" -ForegroundColor Green
