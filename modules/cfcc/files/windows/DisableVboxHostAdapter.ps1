param([switch]$Status)

# The VirtualBox Host-Only Network adapter makes certain LAN discovery operations
# from "old" games such as TF2 and Quake 3 not work. Since we barely use VBox,
# we just disable it.
#
# ChatGPT wrote this entire thing, and it worked out of the box.
# Then Claude came along.

$adapter = Get-NetAdapter | Where-Object { $_.Name -match '^VirtualBox Host-Only' -or $_.InterfaceDescription -match '^VirtualBox Host-Only' } | Select-Object -First 1

if ($Status) {
    if ($null -ne $adapter -and $adapter.Status -eq "Up") {
        Write-Output "'$($adapter.Name)' is enabled - disable needed."
        exit 0
    }
    Write-Output "No enabled VirtualBox Host-Only adapter found."
    exit 1
}

if ($null -eq $adapter) {
    Write-Output "No VirtualBox Host-Only adapter found."
    exit 0
}

if ($adapter.Status -eq "Up") {
    Write-Output "Attempting to disable adapter."
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false
    Write-Output "'$($adapter.Name)' has been disabled."
} else {
    Write-Output "'$($adapter.Name)' is already disabled."
}

exit 0
