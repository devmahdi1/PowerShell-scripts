# Filename: BootMenu.ps1
param (
    [string]$Choice
)

function Show-Menu {
    Write-Host "Select an option:"
    Write-Host "1. Enter BIOS"
    Write-Host "2. Boot Menu"
    Write-Host "3. Exit"

    $input = Read-Host "Enter your choice (1, 2, or 3)"

    switch ($input) {
        1 { Enter-BIOS }
        2 { Enter-BootMenu }
        3 { Exit }
        default { Write-Host "Invalid choice. Try again."; Show-Menu }
    }
}

function Enter-BIOS {
    Write-Host "Restarting and entering BIOS..."
    shutdown.exe /r /fw /t 0  # Forces a restart and enters BIOS (UEFI firmware)
}

function Enter-BootMenu {
    Write-Host "Restarting and entering Boot Menu..."
    shutdown.exe /r /o /t 0  # Forces a restart and opens the boot options menu
}

function Exit {
    Write-Host "Exiting the program."
}

Show-Menu
