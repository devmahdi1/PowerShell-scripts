# Define the output file path for the hardware checkup report.
# The report will be saved on the user's desktop with the filename 'HardwareCheckupReport.txt'.
$reportPath = "$env:USERPROFILE\Desktop\HardwareCheckupReport.txt"

# Function to write messages to the report file.
# This function takes a string parameter '$message' and appends it to the file specified by $reportPath.
function Write-Report {
    param (
        [string]$message
    )
    Add-Content -Path $reportPath -Value $message
}

# Start the report by adding a header, the current date, and a separator line.
# This section initializes the report with a title, the date of the report, and a visual separator.
Write-Report "=== Comprehensive Hardware Checkup Report ==="
Write-Report "Date: $(Get-Date)" # Logs the current date and time in the report.
Write-Report "---------------------------------`n" # Adds a line separator for clarity and readability.

# Check CPU details.
Write-Report "Checking CPU..."
# Retrieve information about the system's CPU using the CIM (Common Information Model) instance.
$cpu = Get-CimInstance -ClassName Win32_Processor 
# Extract and format key information about the CPU.
$cpuInfo = "CPU: $($cpu.Name), Cores: $($cpu.NumberOfCores), MaxClockSpeed: $($cpu.MaxClockSpeed) MHz"
# Log the extracted CPU information to the report.
Write-Report $cpuInfo

# Suggest improvements if the CPU clock speed is below 1000 MHz.
# This section provides recommendations if the CPU speed is lower than expected, which might indicate performance issues.
if ($cpu.MaxClockSpeed -lt 1000) {
    Write-Report "Issue Detected: CPU Clock Speed is below 1000 MHz."
    Write-Report "Suggested Fix: Ensure your system is not running on power-saving mode or consider upgrading your CPU."
}

# Check RAM details.
Write-Report "`nChecking RAM..."
# Retrieve information about physical memory (RAM) using CIM.
$ram = Get-CimInstance -ClassName Win32_PhysicalMemory 
# Calculate the total RAM capacity in GB. The capacity values are summed and converted from bytes to gigabytes.
$totalRAM = [math]::round(($ram.Capacity | Measure-Object -Sum).Sum / 1GB, 2)
# Format the total RAM information for the report.
$ramInfo = "Total RAM: $totalRAM GB"
# Log the RAM information to the report.
Write-Report $ramInfo

# Provide suggestions if total RAM is below 8 GB.
# This section checks if the total RAM is less than 8 GB and provides recommendations for performance improvement.
if ($totalRAM -lt 8) {
    Write-Report "Issue Detected: Total RAM is below 8 GB."
    Write-Report "Suggested Fix: Upgrade your RAM to improve performance, especially for multitasking or running modern applications."
}

# Check Disk Health.
Write-Report "`nChecking Disk Health..."
# Retrieve information about disk drives using WMI (Windows Management Instrumentation).
$diskDrives = Get-WmiObject -Class Win32_DiskDrive 
# Iterate over each disk drive to gather and log details.
foreach ($disk in $diskDrives) {
    # Extract and format information about the disk drive.
    $diskModel = $disk.Model
    $diskStatus = $disk.Status
    $diskSize = [math]::round($disk.Size / 1GB, 2) # Convert disk size from bytes to gigabytes.
    $diskInfo = "Disk Model: $diskModel, Status: $diskStatus, Size: $diskSize GB"
    # Log the disk information to the report.
    Write-Report $diskInfo

    # Retrieve the S.M.A.R.T. InstanceName for the disk, which is used for checking disk health.
    # S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology) provides indicators of potential disk failures.
    $instanceName = (Get-WmiObject -Query "SELECT * FROM MSStorageDriver_FailurePredictData WHERE VendorSpecific = '$($disk.PNPDeviceID)'" | Select-Object -ExpandProperty InstanceName)

    # Perform a S.M.A.R.T. health check if InstanceName is available.
    if ($instanceName) {
        $smartStatus = (Get-WmiObject -Query "SELECT * FROM MSStorageDriver_FailurePredictStatus WHERE InstanceName='$instanceName'" | Select-Object -ExpandProperty PredictFailure)
        if ($smartStatus -eq $false) {
            Write-Report "S.M.A.R.T. Status: OK" # No potential failure detected.
        } else {
            Write-Report "Issue Detected: S.M.A.R.T. Status indicates potential disk failure."
            Write-Report "Suggested Fix: Backup your data immediately and consider replacing the disk as soon as possible."
        }
    } else {
        Write-Report "Unable to retrieve S.M.A.R.T. status for $diskModel."
    }

    # Check for bad sectors and file system errors using chkdsk.
    # `chkdsk` is a utility to check and repair disk file system errors and bad sectors.
    $diskCheck = chkdsk $disk.DeviceID[0] /f # Perform a file system check and fix errors.
    if ($diskCheck -match "Windows has made corrections to the file system") {
        Write-Report "Issue Detected: Disk errors found and corrected."
        Write-Report "Suggested Fix: Monitor the disk closely. If issues persist, consider replacing the drive."
    }
}

# Check Battery (if applicable).
Write-Report "`nChecking Battery..."
# Retrieve information about the battery using CIM.
$battery = Get-CimInstance -ClassName Win32_Battery 
if ($battery) {
    # Extract and format battery status and full charge capacity.
    $batteryStatus = "Battery Status: $($battery.BatteryStatus)"
    $batteryCapacity = "Battery Full Charge Capacity: $($battery.FullChargeCapacity / 1000) mWh" # Convert to mWh.
    Write-Report $batteryStatus
    Write-Report $batteryCapacity

    # Provide suggestions if battery capacity is below 20,000 mWh.
    if ($battery.FullChargeCapacity -lt 20000) {
        Write-Report "Issue Detected: Battery Full Charge Capacity is below 20000 mWh."
        Write-Report "Suggested Fix: Consider replacing your battery as it may not hold a charge well."
    }
} else {
    Write-Report "No Battery Detected or Battery Check Not Applicable"
}

# Check System Files Integrity.
Write-Report "`nChecking System Files Integrity..."
# Run the System File Checker tool to scan and verify the integrity of protected system files.
$sfcResult = sfc /scannow 
if ($sfcResult -match "no integrity violations") {
    Write-Report "System File Check: OK - No Integrity Violations" # No issues detected with system files.
} else {
    Write-Report "Issue Detected: System File Check found integrity violations."
    Write-Report "Suggested Fix: Run 'DISM /Online /Cleanup-Image /RestoreHealth' in PowerShell as an administrator, followed by 'sfc /scannow' again."
}

# Check Network Adapters.
Write-Report "`nChecking Network Adapters..."
# Retrieve information about network adapters with a filter for only those that are connected.
$networkAdapters = Get-CimInstance -ClassName Win32_NetworkAdapter -Filter "NetConnectionStatus=2" 
# Iterate over each active network adapter and log its details.
foreach ($adapter in $networkAdapters) {
    Write-Report "Adapter: $($adapter.Name), Status: Connected"
}

# Provide suggestions if no active network adapters are found.
if ($networkAdapters.Count -eq 0) {
    Write-Report "Issue Detected: No active network adapters found."
    Write-Report "Suggested Fix: Check your network connections, ensure network drivers are up to date, and try resetting your network settings."
}

# Check Display Adapters (Graphics).
Write-Report "`nChecking Display Adapters..."
# Retrieve information about display adapters (graphics cards).
$displayAdapters = Get-CimInstance -ClassName Win32_VideoController 
# Iterate over each display adapter and log its details.
foreach ($adapter in $displayAdapters) {
    $adapterInfo = "Adapter: $($adapter.Name), Video Mode: $($adapter.VideoModeDescription), Status: $($adapter.Status)"
    Write-Report $adapterInfo # Log the details of each display adapter.
}

# Provide suggestions if display adapter issues are found.
# Check if the status of any display adapter is not "OK" and provide recommendations for resolving such issues.
if ($displayAdapters.Status -ne "OK") {
    Write-Report "Issue Detected: Display adapter is not functioning properly."
    Write-Report "Suggested Fix: Update or reinstall your graphics drivers. If issues persist, consider testing with another display adapter."
}

# Check Sound Devices.
Write-Report "`nChecking Sound Devices..."
# Retrieve information about sound devices.
$soundDevices = Get-CimInstance -ClassName Win32_SoundDevice 
# Iterate over each sound device and log its details.
foreach ($device in $soundDevices) {
    $deviceInfo = "Sound Device: $($device.Name), Status: $($device.Status)"
    Write-Report $deviceInfo # Log the details of each sound device.
}

# Provide suggestions if sound device issues are found.
# Check if the status of any sound device is not "OK" and
