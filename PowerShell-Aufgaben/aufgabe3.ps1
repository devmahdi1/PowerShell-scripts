#Aufgabe 3: Systemmonitoring
#Aufgabe
#Erstelle ein PowerShell-Skript, das die CPU- und Speicherauslastung eines Systems überwacht und alle 5 Sekunden die Werte in eine Logdatei schreibt. Das #Skript soll laufen, bis es manuell gestoppt wird.



# Pfad zur Logdatei
$logFilePath = "C:\systemauslastung\Systemauslastung.log"

# Logdatei erstellen oder leeren, wenn sie bereits existiert
New-Item -Path $logFilePath -ItemType File -Force

# Funktion zur Überwachung der Systemauslastung
function Monitor-SystemUsage {
    while ($true) {
        # Zeitstempel erstellen
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # CPU-Auslastung ermitteln
        $cpuLoad = (Get-WmiObject -Query "select * from Win32_Processor").LoadPercentage

        # Speicherauslastung ermitteln
        $totalMemory = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
        $freeMemory = (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory * 1KB
        $usedMemory = $totalMemory - $freeMemory
        $memoryUsagePercentage = [math]::Round(($usedMemory / $totalMemory) * 100, 2)

        # Logzeile erstellen
        $logEntry = "$timestamp - CPU: $cpuLoad% - RAM: $memoryUsagePercentage%"

        # Logzeile in die Datei schreiben
        Add-Content -Path $logFilePath -Value $logEntry

        # 5 Sekunden warten
        Start-Sleep -Seconds 5
    }
}

# Überwachung starten
Monitor-SystemUsage
