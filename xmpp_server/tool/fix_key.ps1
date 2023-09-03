param($vm_name)
Write-Host -ForegroundColor Cyan "Waiting for VM..."
$keyPath = $null
$running = $false
$timeout = [datetime]::Now.AddMinutes(2)
while ([datetime]::Now -lt $timeout) {
    $status = (docker-machine status $vm_name 2>$null)
    if ($status -eq 'Running') {
        $running = $true
    }    
    if ($running -and (-not $keyPath)) {
        $status = docker-machine inspect $vm_name 2>$null
        $keyPath = ($status | ConvertFrom-Json).Driver.SSHKeyPath
    }
    if ($keyPath -and (Test-Path $keyPath)) {
        break
    }
    Start-Sleep -Milliseconds 500 #ms 
}
Write-Host -ForegroundColor Cyan "Fixing key..."
if ($running -and $keyPath -and (Test-Path $keyPath)) {
    icacls $keyPath /inheritance:r
    icacls $keyPath /grant:r "$($env:USERNAME):(R)"
}
