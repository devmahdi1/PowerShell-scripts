# Define the output file for the report
$reportPath = "$env:USERPROFILE\Desktop\HardwareCheckupReport.txt"

# Function to write to the report
function Write-Report {
    param (
        [string]$message
    )
    Add-Content -Path $reportPath -Value $message
}

# Start the report
Write-Report "=== Comprehensive Hardware Checkup Report ==="
Write-Report "Date: $(Get-Date)"
Write-Report "---------------------------------`n"

# Check CPU
Write-Report "Checking CPU..."
$cpu = Get-CimInstance -ClassName Win32_Processor
$cpuInfo = "CPU: $($cpu.Name), Cores: $($cpu.NumberOfCores), MaxClockSpeed: $($cpu.MaxClockSpeed) MHz"
Write-Report $cpuInfo

# Suggestion if CPU is below a certain speed
if ($cpu.MaxClockSpeed -lt 1000) {
    Write-Report "Issue Detected: CPU Clock Speed is below 1000 MHz."
    Write-Report "Suggested Fix: Ensure your system is not running on power-saving mode or consider upgrading your CPU."
}

# Check RAM
Write-Report "`nChecking RAM..."
$ram = Get-CimInstance -ClassName Win32_PhysicalMemory
$totalRAM = [math]::round(($ram.Capacity | Measure-Object -Sum).Sum / 1GB, 2)
$ramInfo = "Total RAM: $totalRAM GB"
Write-Report $ramInfo

# Suggestion if RAM is below 8 GB (adjust based on needs)
if ($totalRAM -lt 8) {
    Write-Report "Issue Detected: Total RAM is below 8 GB."
    Write-Report "Suggested Fix: Upgrade your RAM to improve performance, especially for multitasking or running modern applications."
}

# Check Disk
Write-Report "`nChecking Disk Health..."
$diskDrives = Get-WmiObject -Class Win32_DiskDrive
foreach ($disk in $diskDrives) {
    $diskModel = $disk.Model
    $diskStatus = $disk.Status
    $diskSize = [math]::round($disk.Size / 1GB, 2)
    $diskInfo = "Disk Model: $diskModel, Status: $diskStatus, Size: $diskSize GB"
    Write-Report $diskInfo

    # Retrieve the correct InstanceName for the drive
    $instanceName = (Get-WmiObject -Query "SELECT * FROM MSStorageDriver_FailurePredictData WHERE VendorSpecific = '$($disk.PNPDeviceID)'" | Select-Object -ExpandProperty InstanceName)

    # Perform a quick S.M.A.R.T. check if InstanceName is retrieved
    if ($instanceName) {
        $smartStatus = (Get-WmiObject -Query "SELECT * FROM MSStorageDriver_FailurePredictStatus WHERE InstanceName='$instanceName'" | Select-Object -ExpandProperty PredictFailure)
        if ($smartStatus -eq $false) {
            Write-Report "S.M.A.R.T. Status: OK"
        } else {
            Write-Report "Issue Detected: S.M.A.R.T. Status indicates potential disk failure."
            Write-Report "Suggested Fix: Backup your data immediately and consider replacing the disk as soon as possible."
        }
    } else {
        Write-Report "Unable to retrieve S.M.A.R.T. status for $diskModel."
    }

    # Check for bad sectors using chkdsk
    $diskCheck = chkdsk $disk.DeviceID[0] /f
    if ($diskCheck -match "Windows has made corrections to the file system") {
        Write-Report "Issue Detected: Disk errors found and corrected."
        Write-Report "Suggested Fix: Monitor the disk closely. If issues persist, consider replacing the drive."
    }
}

# Check Battery (if applicable)
Write-Report "`nChecking Battery..."
$battery = Get-CimInstance -ClassName Win32_Battery
if ($battery) {
    $batteryStatus = "Battery Status: $($battery.BatteryStatus)"
    $batteryCapacity = "Battery Full Charge Capacity: $($battery.FullChargeCapacity / 1000) mWh"
    Write-Report $batteryStatus
    Write-Report $batteryCapacity

    # Suggestion if battery capacity is low
    if ($battery.FullChargeCapacity -lt 20000) {
        Write-Report "Issue Detected: Battery Full Charge Capacity is below 20000 mWh."
        Write-Report "Suggested Fix: Consider replacing your battery as it may not hold a charge well."
    }
} else {
    Write-Report "No Battery Detected or Battery Check Not Applicable"
}

# Check System Files Integrity
Write-Report "`nChecking System Files Integrity..."
$sfcResult = sfc /scannow
if ($sfcResult -match "no integrity violations") {
    Write-Report "System File Check: OK - No Integrity Violations"
} else {
    Write-Report "Issue Detected: System File Check found integrity violations."
    Write-Report "Suggested Fix: Run 'DISM /Online /Cleanup-Image /RestoreHealth' in PowerShell as an administrator, followed by 'sfc /scannow' again."
}

# Check Network Adapters
Write-Report "`nChecking Network Adapters..."
$networkAdapters = Get-CimInstance -ClassName Win32_NetworkAdapter -Filter "NetConnectionStatus=2"  # Only active adapters
foreach ($adapter in $networkAdapters) {
    Write-Report "Adapter: $($adapter.Name), Status: Connected"
}

# Suggestion if no active network adapters are found
if ($networkAdapters.Count -eq 0) {
    Write-Report "Issue Detected: No active network adapters found."
    Write-Report "Suggested Fix: Check your network connections, ensure network drivers are up to date, and try resetting your network settings."
}

# Check Display Adapters (Graphics)
Write-Report "`nChecking Display Adapters..."
$displayAdapters = Get-CimInstance -ClassName Win32_VideoController
foreach ($adapter in $displayAdapters) {
    $adapterInfo = "Adapter: $($adapter.Name), Video Mode: $($adapter.VideoModeDescription), Status: $($adapter.Status)"
    Write-Report $adapterInfo
}

# Suggestion if display adapter issues are found
if ($displayAdapters.Status -ne "OK") {
    Write-Report "Issue Detected: Display adapter is not functioning properly."
    Write-Report "Suggested Fix: Update or reinstall your graphics drivers. If issues persist, consider testing with another display adapter."
}

# Check Sound Devices
Write-Report "`nChecking Sound Devices..."
$soundDevices = Get-CimInstance -ClassName Win32_SoundDevice
foreach ($device in $soundDevices) {
    $deviceInfo = "Sound Device: $($device.Name), Status: $($device.Status)"
    Write-Report $deviceInfo
}

# Suggestion if sound device issues are found
if ($soundDevices.Status -ne "OK") {
    Write-Report "Issue Detected: Sound device is not functioning properly."
    Write-Report "Suggested Fix: Update or reinstall your sound drivers. If the issue persists, try using an external sound card."
}

# Check Windows Update Status
Write-Report "`nChecking Windows Update Status..."
$updateStatus = Get-WindowsUpdateLog
Write-Report "Windows Update Log Generated"
# Provide guidance if needed
Write-Report "Suggested Fix: Review the Windows Update log for any issues and resolve them using the Windows Update Troubleshooter."

# End of report
Write-Report "`n=== End of Report ==="

# Open the report
Invoke-Item $reportPath
