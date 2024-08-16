# PowerShell Script to search the entire system for a file, software, or item by name

# Prompt the user for the name to search for
$searchName = Read-Host "Enter the name of the file, software, or item you're looking for"

# Confirm the start of the search
Write-Host "Searching for '$searchName' across all drives. Please wait, this may take some time..."

# Function to search all drives
function Search-System {
    # Get all drives on the system
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }

    # Initialize an array to store found items
    $foundItems = @()

    # Loop through each drive and search for matching files and folders
    foreach ($drive in $drives) {
        try {
            $foundItems += Get-ChildItem -Path "$($drive.Root)" -Recurse -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -like "*$searchName*" }
        } catch {
            Write-Host "Failed to search in $($drive.Root). Skipping this drive." -ForegroundColor Yellow
        }
    }

    return $foundItems
}

# Call the search function
$foundItems = Search-System

# Display the results
if ($foundItems.Count -gt 0) {
    Write-Host "`nFound the following items:"
    $foundItems | ForEach-Object { Write-Host $_.FullName }
} else {
    Write-Host "`nNo items found matching '$searchName'."
}
