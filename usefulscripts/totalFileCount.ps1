# Define a function to calculate the total number of files and their total size in a specified path
function Get-FileStatistics {
    param (
        [string]$Path  # Path to the directory to analyze
    )
    
    # Initialize counters to keep track of total file count and total file size
    $totalFileCount = 0
    $totalFileSize = 0

    # Retrieve all files in the directory and its subdirectories
    # -Recurse option is used to include files from all subdirectories
    # -File option ensures only files (not directories) are retrieved
    $files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue

    # Iterate over each file found
    foreach ($file in $files) {
        # Increment the file count
        $totalFileCount++
        # Add the file's size to the total file size
        $totalFileSize += $file.Length
    }

    # Return a hashtable containing file count and total size in gigabytes
    return @{
        FileCount = $totalFileCount
        TotalSizeGB = [math]::Round($totalFileSize / 1GB, 2)  # Convert bytes to gigabytes and round to 2 decimal places
    }
}

# Get a list of all file system drives on the computer
$drives = Get-PSDrive -PSProvider FileSystem

# Initialize counters for aggregating file statistics across all drives
$totalFileCount = 0
$totalFileSizeGB = 0
$freeSpaceGB = 0

# Process each drive in the list
foreach ($drive in $drives) {
    $path = $drive.Root  # Get the root path of the current drive
    $driveInfo = Get-PSDrive -Name $drive.Name  # Retrieve information about the drive

    # Call the Get-FileStatistics function to get file statistics for the current drive
    $stats = Get-FileStatistics -Path $path

    # Update the aggregated file count and size
    $totalFileCount += $stats.FileCount
    $totalFileSizeGB += $stats.TotalSizeGB

    # Calculate free space on the drive and add it to the total free space
    # Convert bytes to gigabytes for free space
    $freeSpaceGB += [math]::Round($driveInfo.Free / 1GB, 2)
}

# Output the results
# Display total number of files
Write-Host "Total number of files: $totalFileCount"
# Display total size of files in gigabytes
Write-Host "Total size of files (GB): $totalFileSizeGB"
# Display total free space in gigabytes
Write-Host "Total free space (GB): $freeSpaceGB"
