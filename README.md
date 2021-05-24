# Catering Service 
## Konfiguacja
1. W `SQL Server Configuration Manager` wybierz kolejno `SQL Server Network Configuration` >> `Protocols for MSSQLSERVER` >> PPM na `TCP/IP` >> Enable 
2. W `SQL Server Management Studio` dodajemy nowego użytkownika poprzez wejście w `Security` >> PPM na `Logins` >> `New login...`
3. Ustawiamy nazwę użytkownika, zaznaczamy `SQL Server authentication` i wpisujemy hasło. Z prawej strony w `Server Roles` zaznaczamy wszystkie role dla nowego użytkownika i klikamy `OK`.
4. W pliku `application.properties` podajemy nazwę użytkownika i hasło nowo utworzonego loginu

## Jak dodać kolejną funkcję SQL?
1. Dodaj niezbędne metody w nowym lub istniejącym controllerze
2. Dodaj przycisk w pliku `index.html` z odpowiednim przekierowaniem
3. Dodaj nowy szablon w `src/main/resources/templates`, np. formularz do wypełnienia albo widok do wyświetlania danych
4. Dodaj metodę z zapytaniem SQL w nowym lub istniejącym serwisie
5. Przetestuj rozwiązanie

## Dokumentacja
1. https://getbootstrap.com/docs/4.0/getting-started/introduction/
2. https://www.thymeleaf.org/doc/tutorials/3.0/thymeleafspring.html