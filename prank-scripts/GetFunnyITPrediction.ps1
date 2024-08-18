# Define a function to ask questions and give a humorous prediction for IT apprentices
function Get-FunnyITPrediction {
    # Ask the user for their name
    $name = Read-Host "Was ist dein Name?"
    
    # Ask the user for their age and convert the input to an integer
    $age = [int](Read-Host "Wie alt bist du?")
    
    # Ask the user for their favorite color
    $favoriteColor = Read-Host "Was ist deine Lieblingsfarbe?"
    
    # Ask the user for their dream job
    $dreamJob = Read-Host "Was ist dein Traumberuf?"
    
    # Ask the user for their favorite hobby
    $hobby = Read-Host "Was ist dein Lieblingshobby?"
    
    # Ask the user for their favorite programming language
    $favProgrammingLanguage = Read-Host "Was ist deine Lieblings-Programmiersprache?"
    
    # Ask the user which technological trend excites them the most
    $techTrend = Read-Host "Welcher technologische Trend begeistert dich am meisten (z.B. KI, Blockchain, Cloud Computing)?"

    # Define a list of IT-related professions
    $itProfessions = @(
        "Informatiker",
        "IT-Techniker",
        "Softwareentwickler",
        "Plattformentwickler",
        "Datenanalyst",
        "Systemadministrator",
        "Netzwerkadministrator",
        "Sicherheitsanalyst",
        "IT-Projektmanager",
        "DevOps-Ingenieur",
        "Machine Learning Engineer",
        "Cloud Architekt",
        "Webentwickler",
        "UX/UI-Designer"
    )

    # Check if the user’s dream job is in the list of IT professions
    if ($itProfessions -contains $dreamJob) {
        # Create a humorous prediction message based on the user's input
        $prediction = @"
Hallo, $name!

Du bist $age Jahre alt und träumst davon, als $dreamJob in der IT-Branche durchzustarten. Hier ist, was dich erwartet:

1. **Dein Code wird so präzise sein, dass du bald die Titel „Code-Zauberer“ und „Debugging-Guru“ tragen wirst.** In deiner Zukunft wird es keinen Bug geben, der nicht durch deinen magischen Zauberstab (auch bekannt als die Tastatur) verbannt werden kann.

2. **Deine Lieblingsfarbe $favoriteColor wird zur Farbe deiner Programmierumgebung.** Dein Bildschirm wird in $favoriteColor erstrahlen und dir ständig ein Lächeln ins Gesicht zaubern – ein wahrer Farbrausch im IT-Alltag!

3. **Mit deiner Lieblings-Programmiersprache $favProgrammingLanguage wirst du die Welt der Softwareentwicklung revolutionieren.** Die Menschen werden nicht nur deinen Code bewundern, sondern auch anfangen, deine Sprache zu sprechen – in jeder Konferenz, in jedem Forum.

4. **Der technologische Trend, der dich begeistert – $techTrend – wird dein neuer Spielplatz sein.** Du wirst in der Lage sein, innovative Projekte zu entwickeln, die entweder das nächste große Ding in der Tech-Welt sein werden oder dir den Titel „Trendsetter“ einbringen.

5. **Egal, ob du als $dreamJob arbeitest, du wirst immer ein Leben voller interessanter Herausforderungen haben.** Wenn du beispielsweise als **Datenanalyst** arbeitest, wirst du in der Lage sein, versteckte Muster zu finden, die andere übersehen. Wenn du als **Cloud Architekt** tätig bist, wirst du die Welt der virtuellen Maschinen beherrschen und immer einen Schritt voraus sein.

6. **Erwarte, dass du in der IT-Welt als die Person bekannt wirst, die immer die coolsten Tricks und Tipps auf Lager hat.** Dein zukünftiger Arbeitsplatz wird ein Ort sein, an dem du nicht nur den Code meisterst, sondern auch die Herzen deiner Kollegen mit deinem charmanten Humor gewinnst.

7. **Natürlich wirst du in deinem Alltag von epischen Fehlermeldungen und chaotischen Code-Schnipseln begleitet werden, die du mit Bravour bewältigen wirst.** Du wirst die beruhigende Stimme der „It’s not a bug, it’s a feature“-Philosophie finden, die dich durch die härtesten Zeiten begleitet.

Mach dich bereit, dein zukünftiges Abenteuer als IT-Profi zu starten – es wird eine Reise voller Lacher, Herausforderungen und unzähliger Tassen Kaffee sein!

Viel Glück und möge der Code immer mit dir sein!
"@
    } else {
        # If the dream job is not in the list of IT professions, provide a general message
        $prediction = "Es scheint, dass du nicht speziell an einer IT-Ausbildung interessiert bist. Keine Sorge, auch ohne IT wirst du sicherlich eine großartige Zukunft haben. Viel Erfolg bei deinen anderen Zielen!"
    }

    # Display the prediction message to the user
    Write-Output $prediction
}

# Call the function to execute the script
Get-FunnyITPrediction
