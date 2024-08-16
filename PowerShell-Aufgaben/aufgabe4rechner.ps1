#Aufgabe 4: Taschenrechner
#Aufgabe
#Erstelle ein PowerShell-Skript, das als Taschenrechner fungiert. 
#Der Benutzer soll zwei Zahlen eingeben und eine Operation auswählen können (Addition, Subtraktion, Multiplikation, Division). 
#Das Skript soll das Ergebnis berechnen und ausgeben.



# Funktion zur Durchführung der Berechnung
function Calculate{
param(
[double]$num1,
[double]$num2,
[double]$num3,
[double]$num4,
[string]$operation

)

switch ($operation){
"+" {return $num1 + $num2 - $num3 * $num4}
"-" {return $num1 - $num2 * $num3 + $num4}
"*" {return $num1 * $num2 - $num3 + $num4}

"/" {
if ($num4 -eq 0){
return "Fehler: Division durch Null ist nicht erlaubt."
}
else{return $num1 / $num2 /$num3 /$num4}

}
default {return "Ungültige Operation"}

}
}


# Benutzer zur Eingabe der ersten Zahl auffordern
$num1 = Read-Host "Geben Sie die 1 Zahl ein" | Out-String
$num1 = [double]$num1.Trim()

# Benutzer zur Auswahl der Operation auffordern
$operation = Read-Host "Wählen Sie die Operation (+, -, *, /)"


# Benutzer zur Eingabe der zweiten Zahl auffordern
$num2 = Read-Host "Geben Sie die 2 Zahl ein" | Out-String
$num2 = [double]$num2.Trim()

# Benutzer zur Auswahl der Operation auffordern
$operation1 = Read-Host "Wählen Sie die Operation (+, -, *, /)"

# Benutzer zur Eingabe der dritten Zahl auffordern
$num3 = Read-Host "Geben Sie die 3 Zahl ein" | Out-String
$num3 = [double]$num3.Trim()

# Benutzer zur Auswahl der Operation auffordern
$operation2 = Read-Host "Wählen Sie die Operation (+, -, *, /)"

# Benutzer zur Eingabe der dritten Zahl auffordern
$num4 = Read-Host "Geben Sie die 4 Zahl ein" | Out-String
$num4 = [double]$num4.Trim()


# Berechnung durchführen
$result = Calculate -num1 $num1 -num2 $num2 -num3 $num3 -num4 $num4 -operation $operation


# Ergebnis ausgeben
Write-Output "Das Ergebnis der Operation $num1 $operation $num1 $operation2 $num3 $operation2 $num4 ist: $result"
