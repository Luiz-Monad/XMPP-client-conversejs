$ScriptPath = @(
    $(try { $script:psEditor.GetEditorContext().CurrentFile.Path } catch {}), 
    $script:MyInvocation.MyCommand.Path, 
    $script:PSCommandPath, 
    $(try { $script:psISE.CurrentFile.Fullpath.ToString() } catch {}),
    $PSScriptRoot.ToLower() ) | 
    ForEach-Object { if ($_) { $_.ToLower() } } | 
    Split-Path -EA 0 | Get-Unique | Select-Object -First 1
Push-Location $ScriptPath

Add-PathVariable (Get-Item './tool').FullName

$vm_name = 'dockervm'

$status = (docker-machine ls -f '{{.Name}}' 2>$null)
if ($status -notcontains $vm_name) {
    Write-Host -ForegroundColor Cyan "Creating VM..."
    $iso = "file://" + (Get-Item './vm/boot2docker.iso').FullName -replace "\\", "/"
    Start-Process -FilePath pwsh -ArgumentList `
        '-c', './tool/fix_key.ps1', $vm_name
    docker-machine create --driver vmware `
        --vmware-boot2docker-url $iso `
        --vmware-cpu-count 8 `
        --vmware-memory-size 4096 `
        --vmware-network-type bridged `
        $vm_name
    Write-Host -ForegroundColor Cyan "VM Created!"
}

$status = (docker-machine status $vm_name 2>$null)
if ( $status -and ($status -ne 'Running')) {
    Write-Host -ForegroundColor Cyan "Starting VM..."
    docker-machine start $vm_name
    Write-Host -ForegroundColor Cyan "VM Started!"
}

docker-machine env $vm_name --shell powershell | invoke-expression
Write-Host -ForegroundColor Cyan "Docker Env Set!"

docker info

code ..

Pop-Location
