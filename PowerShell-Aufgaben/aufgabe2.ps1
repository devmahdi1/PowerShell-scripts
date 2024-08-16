## Aufgabe 2: Benutzerverwaltung
#Erstelle ein PowerShell-Skript, das eine Liste von Benutzern aus einer CSV-Datei importiert und für jeden Benutzer ein Verzeichnis erstellt. 
#Die CSV-Datei enthält die Spalten "Username" und "Full Name".



# Pfad zur CSV-Datei
$csvFilePath = "C:\Daten\users.csv"

# Basisverzeichnis, in dem die Benutzerverzeichnisse erstellt werden sollen
$baseDirectory = "O:\Benutzerverzeichnisse"

# Sicherstellen, dass das Basisverzeichnis existiert
if (-not (Test-Path -Path $baseDirectory)) {
    New-Item -Path $baseDirectory -ItemType Directory
}

# CSV-Datei importieren
$userList = Import-Csv -Path $csvFilePath

# Für jeden Benutzer ein Verzeichnis erstellen
foreach ($user in $userList) {
    $username = $user.Username
    $fullName = $user.FullName

    # Benutzerverzeichnis erstellen
    $userDirectory = Join-Path -Path $baseDirectory -ChildPath $username

    if (-not (Test-Path -Path $userDirectory)) {
        New-Item -Path $userDirectory -ItemType Directory
        Write-Output "Verzeichnis erstellt für $fullName ($username): $userDirectory"
    } else {
        Write-Output "Verzeichnis für $fullName ($username) existiert bereits: $userDirectory"
    }
}
