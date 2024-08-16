# Hacker Mask Logo
$mask = @'
                  ______
               .-"      "-.
              /            \
             |              |
             |,  .-.  .-.  ,|
             | )(_o/  \o_)( |
             |/     /\     \|
      (@_    (_     ^^     _)
 _     ) \____\__|IIIIII|__/_________________________
(_)@8@8{}<___________________________________________>
       )_/     |-\IIIIII/-|
      (@       \        /
                `------`
'@

# Clear the screen
Clear-Host

# Display the mask logo
Write-Host $mask -ForegroundColor Green

# Simulated Hacking Commands
$commands = @(
    "Initializing attack vector...",
    "Connecting to remote server at 192.168.1.102...",
    "Spoofing MAC address...",
    "Performing ARP poisoning...",
    "Bypassing IDS and IPS systems...",
    "Establishing encrypted communication channel...",
    "Injecting malicious payload...",
    "Escalating privileges to root...",
    "Gaining persistent access...",
    "Accessing system logs...",
    "Wiping system logs...",
    "Injecting code into svchost.exe...",
    "Decrypting stored credentials...",
    "Accessing confidential files: financial_records.xlsx...",
    "Exfiltrating data to secure server...",
    "Encrypting all exfiltrated data...",
    "Injecting ransomware into the system...",
    "Generating cryptographic key for decryption...",
    "Uploading payload to target system...",
    "Executing remote shell...",
    "Covering tracks...",
    "Terminating connection...",
    "Hiding backdoor for future access..."
)

# Simulate running commands with a delay
foreach ($command in $commands) {
    # Random delay for realism
    $delay = Get-Random -Minimum 700 -Maximum 2000
    Write-Host $command -ForegroundColor Cyan
    Start-Sleep -Milliseconds $delay
}

# Simulated Network Activity
$networkTraffic = @(
    "Sending 512 bytes to 192.168.1.102...",
    "Received 1024 bytes from 192.168.1.102...",
    "Sending 2048 bytes to 192.168.1.102...",
    "Received 4096 bytes from 192.168.1.102...",
    "Connection reset by peer, retrying...",
    "Re-establishing connection...",
    "Sending 8192 bytes to 192.168.1.102...",
    "Received 16384 bytes from 192.168.1.102...",
    "Connection stable."
)

Write-Host "`nSimulating network traffic..." -ForegroundColor Yellow
foreach ($traffic in $networkTraffic) {
    $delay = Get-Random -Minimum 500 -Maximum 1500
    Write-Host $traffic -ForegroundColor White
    Start-Sleep -Milliseconds $delay
}

# Simulated Progress Bar for Data Exfiltration
Write-Host "`nExfiltrating data..." -ForegroundColor Magenta
for ($i = 0; $i -le 100; $i += (Get-Random -Minimum 5 -Maximum 20)) {
    Write-Progress -Activity "Data Exfiltration in Progress" -Status "$i% Complete" -PercentComplete $i
    Start-Sleep -Milliseconds (Get-Random -Minimum 200 -Maximum 600)
}

Write-Host "`nExfiltration complete!" -ForegroundColor Green

# Final Message
Write-Host "`nOperation completed successfully. All traces removed." -ForegroundColor Green
