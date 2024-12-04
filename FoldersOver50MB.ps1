# Built for doing large Enterprise Home Drive Audits - E.g. User Folders on OES File Servers over 50MB

$directoryPath = Read-Host "Enter directory path"

if (Test-Path $directoryPath -PathType Container) {
    Write-Host "Searching for folders over 50MB in size in $directoryPath" -ForegroundColor Cyan

    $subDirectories = Get-ChildItem $directoryPath -Directory
    $results = @()

    #to change the size, change the MB size, to search for folders over that siz within "if ($folderSizeMB -gt 50) {"
    foreach ($dir in $subDirectories) {
        $folderSize = Get-ChildItem $dir.FullName -Recurse | Measure-Object -Property Length -Sum
        $folderSizeMB = $folderSize.Sum / 1MB
        if ($folderSizeMB -gt 50) {
            $result = "$($dir.FullName) - Size: $($folderSizeMB.ToString("N2")) MB"
            $results += $result
            Write-Host $result -ForegroundColor Yellow
        }
    }

    if ($results.Count -eq 0) {
        Write-Host "No folders over 50MB were found." -ForegroundColor Green
    }

    $savePath = Read-Host "Enter the full path where you want to save the results (including filename and .txt extension)"
    try {
        $results | Out-File -FilePath $savePath -Encoding UTF8
        Write-Host "Results saved to $savePath" -ForegroundColor Green
    } catch {
        Write-Host "Failed to save results. Please check the path and try again." -ForegroundColor Red
    }
} else {
    Write-Host "Directory path '$directoryPath' is not valid." -ForegroundColor Red
}
