# The VirtualBox Host-Only Network adapter makes certain LAN discovery operations
# from "old" games such as TF2 and Quake 3 not work. Since we barely use VBox,
# we just disable it.
#
# ChatGPT wrote this entire thing, and it worked out of the box.

$adapter = Get-NetAdapter | Where-Object { $_.Name -eq "VirtualBox Host-Only Network" }

if ($null -eq $adapter) {
    Write-Output "No 'VirtualBox Host-Only Network' found."
    exit 0
}

if ($adapter.Status -eq "Up") {
    Write-Output "'Attempting to disable adapter."
    Disable-NetAdapter -Name "VirtualBox Host-Only Network" -Confirm:$false
    Write-Output "'VirtualBox Host-Only Network' has been disabled."
} else {
    Write-Output "'VirtualBox Host-Only Network' is already disabled."
}

exit 0
