## Aufgabe 1: Backup-Skript
#Erstelle ein PowerShell-Skript, das ein Verzeichnis (z.B. "C:\Daten") in ein anderes Verzeichnis (z.B. "D:\Backup") kopiert. 
#Das Skript soll nur geänderte Dateien kopieren und ein Logfile erstellen, das den Backup-Vorgang dokumentiert.

#Lösung:

#C:\Backup\verzeichnis1
#O:\Daten


Skripts

# Pfad zum Quellverzeichnis
$sourceDirectory = "C:\Backup\verzeichnis1"

# Pfad zum Zielverzeichnis
$destinationDirectory = "O:\Daten"

#Logfile
$logFile = "C:\BackupLog.log"

#Datum
$date = Get-Date

# Sicherstellen, dass das Zielverzeichnis existiert
if (-not (Test-Path -Path $destinationDirectory)) {
    New-Item -Path $destinationDirectory -ItemType Directory
}

# Ordner und seine Inhalte kopieren
Copy-Item -Path $sourceDirectory -Destination $destinationDirectory -Recurse

Write-Output "Ordner und seine Inhalte wurden erfolgreich kopiert."

$output = "Backup erfolgreich / Datum: $date"

Add-Content -Path $logFile -Value $output
