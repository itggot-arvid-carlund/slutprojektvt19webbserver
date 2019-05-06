# slutprojektvt19webbserver

# Projektplan

## 1. Projektbeskrivning
Privat forum med Inloggningssystems. Ska finnas funktion med att skapa inlägg, ta bort och redigera + eventuellt en upvote och downvote funktion. Inloggningssystem.

## 2. Vyer (sidor)
    
    Första sidan man kommer till är en informati0nssida som man därefter ska klicka sig vidare ifrån för att komma till inlogg och registrering. ('/')

    Login sidan och regestreringssidan är number 2 och där ska du alltså logga in eller skapa en ny användare då man måste göra dettta för att kunna se grejerna som har publicerats. ('/login')

    Efter login kommer man till welcome sidan där man får välja om man vill skapa och eller redigera + ta bort tidigare posts, eller logout knapp och sist om man vill se alla posts som publicerats av användare.  ('/welcome')

    En post-sida ('/post_all')
    Här ska man kunna se alla posts som har publicerats och kunna upvota och downvota (om tid innfinner sig). 

    En post-redigeringssida ('/post_edit')
    Här ska man kunna redigera sin post

    En post-sida där man kan skapa, ta bort och se sina egna inlägg ('/blogg_create')
    Här ska man kunna se alla sina egna posts och kunna redigera och ta bort dem om man vill

## 3. Funktionalitet (med sekvensdiagram)
## 4. Arkitektur (Beskriv filer och mappar)
Följer MVC strukturen med en views-mapp där alla filer är slim, en slim per sida + layout fil. En controller fil - app.rb och en funktionsfil - function.rb. Själva databasen ligger i sin egen mapp db
## 5. (Databas med ER-diagram)
    Se diagram mappen!!