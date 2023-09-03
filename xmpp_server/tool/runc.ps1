[CmdletBinding()]
param (    
    [Parameter(ParameterSetName="pipe", ValueFromPipeline=$true, Position=0, Mandatory=$true)][string]$image,
    [Parameter()][switch]$exec,
    [Parameter()]$entrypoint,
    [Parameter()]$environment,
    [Parameter()]$mount,
    [Parameter()]$as,
    [Parameter()]$port,
    [Parameter(ValueFromRemainingArguments=$true)]$args_app
)

if ($env:RUNC_MOUNT) {
    $mount = (Get-Location).Path
    $as = '/mnt'
}

if ($mount) {
    if ((Get-Command vmrun -ErrorAction Ignore).Count -gt 0) {
        # outside mount
        $share = (Split-Path $mount -LeafBase)
        if ($env:RUNC_VMMOUNT -ne $share) {
            $dm = (vmrun list | Select-String docker).Line
            Write-Verbose "vmware $dm"
            $folder = (Get-Item $mount).FullName
            vmrun -T ws removeSharedFolder $dm $share
            vmrun -T ws addSharedFolder $dm $share $folder
            $env:RUNC_VMMOUNT = $share
        }
        Write-Verbose "mounting $folder -> $share"
        $target = $(if ($as) { $as } else { $share })
        $mnt = "type=bind,source=/mnt/hgfs/$share,target=$target,consistency=cached"
        Write-Verbose "mount $mnt"
    } else {
        # dind - docker in docker mount
        if ("$(df $mount)".Contains('-fuse')) {
            # vmware fuse support
            $fuse = ((df $mount --output=target) | Select-Object -Skip 1)
            $dc = ( docker ps --format json | ConvertFrom-Json ).Id | ForEach-Object { 
                docker inspect $_ --format json | ConvertFrom-Json 
            }
            $realpath = (($dc.Mounts | Where-Object Destination -eq $fuse).Source | Select-Object -First 1)
            $mount = (Join-Path $realpath $mount.Substring($fuse.Length))
        }
        $target = $(if ($as) { $as } else { $share })
        Write-Verbose "mounting $mount -> $target"
        $mnt = "type=bind,source=$mount,target=$target,consistency=cached"
        Write-Verbose "mount $mnt"
    }
}

$allports = @()
if ( -not $port ) { $allports += @( '--publish-all' ) }

$args_docker = @()
if ( $entrypoint ) { $args_docker += @( '--entrypoint', $entrypoint ) }
if ( $environment ) { $args_docker += ( $environment | ForEach-Object { @( '--env', $_ ) } ) }
if ( $mnt ) { $args_docker += @( '--mount', $mnt ) }
if ( $port ) { $args_docker += @( '--publish', "$($port):$($port)" ) }
Write-Verbose "docker args: $args_docker"

Write-Verbose "image: $image"

if ($exec) {
    $container = $images | Where-Object Image -eq $image | Select-Object -First 1
    if (-not $container) {
        Write-Error "Container running image $image not found!"
        return
    }
}

Write-Verbose "app args: $args_app"

if (-not $exec) {
    docker run --rm -it @allports @args_docker $image @args_app
} else {
    docker exec -it $container.Id @args_app
}
