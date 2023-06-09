from faker import Faker
from lorem_text import lorem
import random
import datetime


fake = Faker('pl_PL')
start_date = datetime.date(1965, 1, 1)
end_date = datetime.date(2023, 6, 3)

all_data = open('data/all_data.data', 'w')


# KATEGORIE
with open('data/kategorie.data', 'w') as f:
    f.write("COPY kategorie FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY kategorie FROM STDIN DELIMITER ';' NULL 'null';\n")

    f.write("0;Sport\n")
    all_data.write("0;Sport\n")
    f.write("1;Literatura\n")
    all_data.write("1;Literatura\n")
    f.write("2;Historia\n")
    all_data.write("2;Historia\n")
    f.write("3;Geografia\n")
    all_data.write("3;Geografia\n")
    f.write("4;Nauka\n")
    all_data.write("4;Nauka\n")
    f.write("5;Muzyka\n")
    all_data.write("5;Muzyka\n")
    f.write("6;Sztuka\n")
    all_data.write("6;Sztuka\n")
    f.write("7;Kino\n")
    all_data.write("7;Kino\n")
    f.write("8;Polityk\n")
    all_data.write("8;Polityk\n")
    f.write("9;Technologia\n")
    all_data.write("9;Technologia\n")
    f.write("10;Inne\n")
    all_data.write("10;Inne\n")

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# ROLE
with open("data/role.data", "w") as f:
    f.write("COPY role FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY role FROM STDIN DELIMITER ';' NULL 'null';\n")

    f.write("0;kapitan\n")
    all_data.write("0;kapitan\n")
    f.write("1;uczestnik\n")
    all_data.write("1;uczestnik\n")
    f.write("2;trener\n")
    all_data.write("2;trener\n")
    f.write("3;gracz zapasowy\n")
    all_data.write("3;gracz zapasowy\n")

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# CITIES
numberOfCities = random.randint(10, 20)
cities = [None for _ in range(numberOfCities)]
with open('data/miejscowosci.data', 'w') as f:
    f.write("COPY miejscowosci FROM STDIN DELIMITER ',' NULL 'null';\n")
    all_data.write("COPY miejscowosci FROM STDIN DELIMITER ',' NULL 'null';\n")
    for i in range(numberOfCities):
        cities[i] = fake.city()
        f.write(f"{i},{cities[i]}\n")
        all_data.write(f"{i},{cities[i]}\n")
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")

# ADRESY
numberOfAddresses = random.randint(20, 40)
with open('data/adresy.data', 'w') as f:
    f.write("COPY adresy FROM STDIN DELIMITER ',' NULL 'null';\n")
    all_data.write("COPY adresy FROM STDIN DELIMITER ',' NULL 'null';\n")

    for i in range(numberOfAddresses):
        s = f"{i},{random.randint(0, numberOfCities-1)},{fake.street_name()},{fake.postcode()},{random.randint(1,40)},{random.randint(1, 100)}\n"
        f.write(s)
        all_data.write(s)
    
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# PYTANIA
numberOfQuestions = random.randint(3000, 4000)
with open('data/pytania.data', 'w') as f:
    f.write("COPY pytania FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY pytania FROM STDIN DELIMITER ';' NULL 'null';\n")

    f.write("0;Po 1582 roku, SUCH jest najczęstszym odpowiednikiem HER. SHE i SUCH zostały połączone w tytule serialu grozy w reżyserii Seana Cunninghama. Odtwórz ten tytuł składający się z dwóch słów.;Friday 13th;7\n")
    all_data.write("0;Po 1582 roku, SUCH jest najczęstszym odpowiednikiem HER. SHE i SUCH zostały połączone w tytule serialu grozy w reżyserii Seana Cunninghama. Odtwórz ten tytuł składający się z dwóch słów.;Friday 13th;7\n")
    f.write("1;Program informacyjny Channel One w dniu 14 maja 2011 roku mówił o bajkowym przedstawieniu obiecanym przez organizatorów ceremonii prezentacji zegarków olimpijskich w Soczi. Zostały one zamontowane, gdy do otwarcia Olimpiady pozostało dokładnie DWADZIEŚCIA MIESIĘCY. Jakie słowa zastąpiliśmy w tekście pytania słowem TWENTY MONTHS?;tysiąc i jedna noc;1\n")
    all_data.write("1;Program informacyjny Channel One w dniu 14 maja 2011 roku mówił o bajkowym przedstawieniu obiecanym przez organizatorów ceremonii prezentacji zegarków olimpijskich w Soczi. Zostały one zamontowane, gdy do otwarcia Olimpiady pozostało dokładnie DWADZIEŚCIA MIESIĘCY. Jakie słowa zastąpiliśmy w tekście pytania słowem TWENTY MONTHS?;tysiąc i jedna noc;1\n")
    f.write("2;W chińskim mieście Xian znajduje się pagoda dzikiego YIH. Według legendy pewien mnich modlił się o pomoc podczas wielkiego głodu. I niebo zesłało jedzenie dla pobożnego starca. Kilka tłustych IH wpadło prosto w jego ręce. Podobną historię opowiadał Munchausen, a w jednej z europejskich stolic postawiono im pomnik. Wymień ich imię i nazwisko.;gęsi;2\n")
    all_data.write("2;W chińskim mieście Xian znajduje się pagoda dzikiego YIH. Według legendy pewien mnich modlił się o pomoc podczas wielkiego głodu. I niebo zesłało jedzenie dla pobożnego starca. Kilka tłustych IH wpadło prosto w jego ręce. Podobną historię opowiadał Munchausen, a w jednej z europejskich stolic postawiono im pomnik. Wymień ich imię i nazwisko.;gęsi;2\n")
    f.write("3;Budując hotel w pobliżu lotniska w Chicago, właściciele zadbali o wszelkie możliwe udogodnienia dla HER. Jednak wkrótce po zajęciu hotelu musieli zainstalować dodatkowe urządzenia, które imitowały szmer fal morskich i rzecznych, szum gałęzi i ciche wycie wiatru. Wymień EE.;izolacja akustyczna;3\n")
    all_data.write("3;Budując hotel w pobliżu lotniska w Chicago, właściciele zadbali o wszelkie możliwe udogodnienia dla HER. Jednak wkrótce po zajęciu hotelu musieli zainstalować dodatkowe urządzenia, które imitowały szmer fal morskich i rzecznych, szum gałęzi i ciche wycie wiatru. Wymień EE.;izolacja akustyczna;3\n")
    f.write("4;Projektant Vadim Kibardin stworzył manipulator przeznaczony do walki z dolegliwością zwaną zespołem cieśni nadgarstka. Nazwa tego manipulatora jest taka sama jak tytuł dzieła, którego premiera odbyła się w 1874 roku. Podaj autora tego dzieła.;[Johann] Strauss;5\n")
    all_data.write("4;Projektant Vadim Kibardin stworzył manipulator przeznaczony do walki z dolegliwością zwaną zespołem cieśni nadgarstka. Nazwa tego manipulatora jest taka sama jak tytuł dzieła, którego premiera odbyła się w 1874 roku. Podaj autora tego dzieła.;[Johann] Strauss;5\n")
    f.write("5;W czasach starożytnych wiele ludów świata przy pochówku oddawało SWOJE ciała. HE odróżnia motocyklistę na motocyklu sportowym, znacznie bardziej niebezpiecznym od innych motocykli, od pozostałych motocyklistów. Wymień JEJ nazwę w dwóch słowach.;pozę embrionalną;10\n")
    all_data.write("5;W czasach starożytnych wiele ludów świata przy pochówku oddawało SWOJE ciała. HE odróżnia motocyklistę na motocyklu sportowym, znacznie bardziej niebezpiecznym od innych motocykli, od pozostałych motocyklistów. Wymień JEJ nazwę w dwóch słowach.;pozę embrionalną;10\n")
    f.write("6;Na opakowaniu słuchawek znanego kanadyjskiego projektanta znajduje się pięć cienkich, poziomych linii równoległych. Wymień JEJ nazwisko.;[Philip] Starck;10\n")
    all_data.write("6;Na opakowaniu słuchawek znanego kanadyjskiego projektanta znajduje się pięć cienkich, poziomych linii równoległych. Wymień JEJ nazwisko.;[Philip] Starck;10\n")
    f.write("7;O NIM mówiło się w latach 20. ubiegłego wieku. ONO bylo tematem rozprawy doktorskiej, w której lekarz Caroline Sjönger Philip doszła do wniosku, że immunoalergiczna bronchopneumopatologia jest faktycznie przyczyną zgonów ludzi. Nazwij JEGO w dwóch słowach.;klątwa faraonów;2\n")
    all_data.write("7;O NIM mówiło się w latach 20. ubiegłego wieku. ONO bylo tematem rozprawy doktorskiej, w której lekarz Caroline Sjönger Philip doszła do wniosku, że immunoalergiczna bronchopneumopatologia jest faktycznie przyczyną zgonów ludzi. Nazwij JEGO w dwóch słowach.;klątwa faraonów;2\n")
    f.write("8;Baron Robert Baden-Powell uważał, że ludność kolonii powinna być rządzona żelazną ręką, a jeśli jej siła nie zostanie zauważona, ZROBIĆ TO. Etykieta wymaga, aby mężczyzna podczas powitania zrobił TO, ale kobieta nie. Które dwa słowa zastąpiliśmy słowem ZROIC TO?;zdjąć rękawicę;2\n")
    all_data.write("8;Baron Robert Baden-Powell uważał, że ludność kolonii powinna być rządzona żelazną ręką, a jeśli jej siła nie zostanie zauważona, ZROBIĆ TO. Etykieta wymaga, aby mężczyzna podczas powitania zrobił TO, ale kobieta nie. Które dwa słowa zastąpiliśmy słowem ZROIC TO?;zdjąć rękawicę;2\n")
    f.write("9;Komentując porażkę Barcelony z AC Milan, portal championat.com zauważył, że Messi jakby przeniósł się do NIEGO. Inna strona nazwała EGO cudownym kwiatem chińskiej sztuki ludowej. Nazwi EGO za pomocą dwóch słów;teatr cieni;0\n")
    all_data.write("9;Komentując porażkę Barcelony z AC Milan, portal championat.com zauważył, że Messi jakby przeniósł się do NIEGO. Inna strona nazwała EGO cudownym kwiatem chińskiej sztuki ludowej. Nazwi EGO za pomocą dwóch słów;teatr cieni;0\n")
    f.write("10;Elektroniczny alfabet dziecka autorów po naciśnięciu mówi literę, a następnie słowo na tę literę i dźwięk związany z tym słowem. Na przykład Ch - zegar, tykanie, SH - szczeniak, szczekanie. W jednym przypadku dźwięk związany z wypowiadanym słowem jest taki sam jak samo słowo i powtarza się trzykrotnie. Napisz to krótkie słowo.;echo;10\n")
    all_data.write("10;Elektroniczny alfabet dziecka autorów po naciśnięciu mówi literę, a następnie słowo na tę literę i dźwięk związany z tym słowem. Na przykład Ch - zegar, tykanie, SH - szczeniak, szczekanie. W jednym przypadku dźwięk związany z wypowiadanym słowem jest taki sam jak samo słowo i powtarza się trzykrotnie. Napisz to krótkie słowo.;echo;10\n")
    f.write("11;Kolizja dwóch samochodów w norweskim miasteczku Bjarkøy, położonym na wyspie w archipelagu Västerålen, od dawna jest omawiana w prasie i nic dziwnego. TAKI samochód i TAKA ciężarówka zderzyły się na TAKIEJ ulicy. Które słowo zastąpiliśmy słowem TAKI?;taki samochód;1\n")
    all_data.write("11;Kolizja dwóch samochodów w norweskim miasteczku Bjarkøy, położonym na wyspie w archipelagu Västerålen, od dawna jest omawiana w prasie i nic dziwnego. TAKI samochód i TAKA ciężarówka zderzyły się na TAKIEJ ulicy. Które słowo zastąpiliśmy słowem TAKI?;taki samochód;1\n")

    for i in range(12, numberOfQuestions):
        s = f"{i};{lorem.words(random.randint(30,50))};{lorem.words(1)};{random.randint(0,10)}\n"
        f.write(s)
        all_data.write(s)

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


#UCZESTNICY
numberOfPlayers = random.randint(800, 1200)
playersBirthday = [None for _ in range(numberOfPlayers)]
with open('data/uczestnicy.data', 'w') as f:
    f.write("COPY uczestnicy FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY uczestnicy FROM STDIN DELIMITER ';' NULL 'null';\n")

    for i in range(numberOfPlayers):
        # Generate a random date between the start and end dates
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)

        playersBirthday[i] = random_date

        # Format the date as a string in the format "YYYY-MM-DD"
        formatted_date = random_date.strftime('%Y-%m-%d')       
        
        s = f"{i};{fake.first_name()};{fake.last_name()};{random.choice(('M', 'F'))};{formatted_date}\n"
        f.write(s)
        all_data.write(s)

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")

# AUTORZY PYTAN
autors = set()
l = [0 for _ in range(40)] # number of questions for each author
que_aut = [None for _ in range(numberOfQuestions)]
with open('data/autorzy_pytan.data', 'w') as f:
    f.write("COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';\n")

    for i in range(numberOfQuestions):
        id_autora = random.choice([i for i in range(30)]+[i for i in range(200,210)])
        autors.add(id_autora)
        que_aut[i] = id_autora
        f.write(f"{id_autora};{i}\n")
        all_data.write(f"{id_autora};{i}\n")
        if(id_autora < 30):
            l[id_autora] += 1
        else:
            l[id_autora-170] += 1
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")

# for a in autors:
#     print(a, playersBirthday[a])

# AUTORZY
with open('data/autorzy.data', 'w') as f:
    f.write("COPY autor FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY autor FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(30):
        f.write(f"{i};{l[i]}\n")
        all_data.write(f"{i};{l[i]}\n")
    for i in range(30, 40):
        f.write(f"{i+170};{l[i]}\n")
        all_data.write(f"{i+170};{l[i]}\n")
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# TURNIEJE
start_date_tourn = datetime.date(1980, 1, 1)
numberOfTournaments = random.randint(20, 30)
datesOfTournaments = [None for _ in range(numberOfTournaments)]
endsOfTournaments = [None for _ in range(numberOfTournaments)]
with open('data/turnieje.data', 'w') as f:
    f.write("COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(numberOfTournaments):
        time_between_dates = end_date - start_date_tourn
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date_tourn + datetime.timedelta(days=random_number_of_days)
        datesOfTournaments[i] = random_date # !!!!!!!!!!!!
        formatted_date = random_date.strftime('%Y-%m-%d')    


        srandom_number_of_days = random.randint(1, 7)
        srandom_date = random_date + datetime.timedelta(days=srandom_number_of_days)
        sformatted_date = srandom_date.strftime('%Y-%m-%d')    
        endsOfTournaments[i] = srandom_date # !!!!!!!!!!!!
        
        s = f"{i};{fake.word()+' '+fake.word()};{lorem.words(5)};{formatted_date};{sformatted_date};{random.randint(0,4)}\n"
        f.write(s)
        all_data.write(s)

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")

for i, t in enumerate(datesOfTournaments):
    print(i, t)

# PYTANIA NA TURNIEJACH
que_tourn = [None]+[_ for _ in range(0, numberOfQuestions)]
tourn_que = [list() for _ in range(numberOfTournaments)]
que_to_choose = [i for i in range(numberOfQuestions)]
with open("data/pytania_na_turniejach.data", "w") as f:
    f.write("COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")

    for j in range(numberOfTournaments):
        for i in range(24):
            #print(j, i, len([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)]))
            que = random.choice([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)])
            que_tourn[que] = j
            tourn_que[j].append(que)
            que_to_choose.remove(que)
            f.write(f"{j};{que};{i+1}\n")
            all_data.write(f"{j};{que};{i+1}\n")
    
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# ZESPOLY
numberOfTeams = random.randint(numberOfTournaments, numberOfTournaments*3)
teamsDateOfCreation = [None for _ in range(numberOfTeams)]
teamsBrokeUpDate = [None for _ in range(numberOfTeams)]

teamsDateOfCreation[0] = datetime.date(2000,2,25)
teamsDateOfCreation[1] = datetime.date(2018,4,20)
teamsDateOfCreation[2] = datetime.date(2010,3,17)
teamsDateOfCreation[3] = datetime.date(2015,11,11)
teamsDateOfCreation[4] = datetime.date(1990,2,28)


with open('data/zespoly.data', 'w') as f:
    f.write("COPY zespoly FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY zespoly FROM STDIN DELIMITER ';' NULL 'null';\n")
    
    f.write(f"0;Natus Vincere;2000-02-25;null;null\n")
    all_data.write(f"0;Natus Vincere;2000-02-25;null;null\n")
    f.write(f"1;Troche matematykow;2018-04-20;null;null\n")
    all_data.write(f"1;Troche matematykow;2018-04-20;null;null\n")
    f.write(f"2;Reakcja lancuchowa;2010-03-17;null;null\n")
    all_data.write(f"2;Reakcja lancuchowa;2010-03-17;null;null\n")
    f.write(f"3;Wszechmocne jajko;2015-11-11;null;null\n")
    all_data.write(f"3;Wszechmocne jajko;2015-11-11;null;null\n")
    f.write(f"4;Klasyczni klauny;1990-02-28;null;null\n")
    all_data.write(f"4;Klasyczni klauny;1990-02-28;null;null\n")

    for i in range(5,numberOfTeams):
        # Generate a random date between the start and end dates
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)

        teamsDateOfCreation[i] = random_date # !!!!!!!!!!!!

        # Format the date as a string in the format "YYYY-MM-DD"
        formatted_date = random_date.strftime('%Y-%m-%d')       
        data_likwidacji = "null"
        if(random.choice([i for i in range(20)]) == 13):
            time_between_dates = end_date - random_date
            days_between_dates = time_between_dates.days
            random_number_of_days = random.randrange(days_between_dates)
            data_likwidacji = random_date + datetime.timedelta(days=random_number_of_days)

            teamsBrokeUpDate[i] = data_likwidacji # !!!!!!!!!!!!

            data_likwidacji = data_likwidacji.strftime('%Y-%m-%d')
        
        city = random.choice([i for i in range(numberOfCities)] + ['null']*3)

        s = f"{i};{fake.word().capitalize()+' '+fake.word()};{formatted_date};{data_likwidacji};{city}\n"
        f.write(s)
        all_data.write(s)

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# SKLADY W ZESPOLACH
# ZMIANY

def checkIfTimesIntersects(_player, _tourn, _playersInTournaments, _datesOfTournaments, _endsOfTournaments):
    if len(_playersInTournaments[_player]) == 0:
        return False
    
    for start, end in _playersInTournaments[_player]:
        if (_datesOfTournaments[_tourn] <= start <= _endsOfTournaments[_tourn] 
           or _datesOfTournaments[_tourn] <= end <= _endsOfTournaments[_tourn]):
            return True
    return False

playersInTournaments = [[] for _ in range(numberOfPlayers)]
tournament_teams = [[] for _ in range(numberOfTournaments)]
textForZmainy =""
with (open('data/sklady_w_zespolach.data', 'w') as f, open('data/zmiany.data', 'w') as zm):
    f.write("COPY sklady_w_zespolach FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY sklady_w_zespolach FROM STDIN DELIMITER ';' NULL 'null';\n")
    
    zm.write("COPY zmiany FROM STDIN DELIMITER ';' NULL 'null';\n")
    textForZmainy += "COPY zmiany FROM STDIN DELIMITER ';' NULL 'null';\n"
    
    for turn in range(numberOfTournaments):
        available_teams = [i for i in range(numberOfTeams) if teamsDateOfCreation[i] <= datesOfTournaments[turn] and (teamsBrokeUpDate[i] == None or teamsBrokeUpDate[i] >= endsOfTournaments[turn])]
        available_players = [i for i in range(numberOfPlayers) 
                             if (playersBirthday[i] <= datesOfTournaments[turn] - datetime.timedelta(days=366*5) 
                                and i not in [que_aut[que] for que in tourn_que[turn]]
                                and not checkIfTimesIntersects(i, turn, playersInTournaments, datesOfTournaments, endsOfTournaments))]
        for i in range(random.randint(5, 20)):
            if(len(available_teams) == 0 or len(available_players) < 8):
                break
            team = random.choice(available_teams)
            tournament_teams[turn].append(team)
            available_teams.remove(team)

            #add capitan
            cap = None
            while(cap == None):
                cap = random.choice(available_players)
                for question in tourn_que[turn]:
                    if que_aut[question] == cap:
                        cap = None
                        break
            
            playersInTournaments[cap].append((datesOfTournaments[turn], endsOfTournaments[turn]))
            available_players.remove(cap)
            f.write(f"{cap};{team};{turn};0\n")
            all_data.write(f"{cap};{team};{turn};0\n")

            #add 5 players
            players = []
            for j in range(5):
                player = None
                while(player == None):
                    player = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question] == player:
                            player = None
                            break
                
                playersInTournaments[player].append((datesOfTournaments[turn], endsOfTournaments[turn]))
                available_players.remove(player)
                players.append(player)
                f.write(f"{player};{team};{turn};1\n")
                all_data.write(f"{player};{team};{turn};1\n")
            
            #add trener
            if(random.randint(0, 1) == 1):
                trener = None
                while(trener == None):
                    trener = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question] == trener:
                            trener = None
                            break
                
                playersInTournaments[trener].append((datesOfTournaments[turn], endsOfTournaments[turn]))
                available_players.remove(trener)
                f.write(f"{trener};{team};{turn};2\n")
                all_data.write(f"{trener};{team};{turn};2\n")
            
            #add zapas
            zapas_players = []
            number_of_zapas = random.randint(0, 2)
            for j in range(number_of_zapas):
                zapas = None
                while(zapas == None):
                    zapas = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question] == zapas:
                            zapas = None
                            break
                
                playersInTournaments[zapas].append((datesOfTournaments[turn], endsOfTournaments[turn]))
                zapas_players.append(zapas)
                available_players.remove(zapas)
                f.write(f"{zapas};{team};{turn};3\n")
                all_data.write(f"{zapas};{team};{turn};3\n")

            

            #add zmiany
            for zap in zapas_players:
                #print(turn, players)
                changed = random.choice(players)
                players.remove(changed)
                cur_text = f"{turn};{changed};{zap};{random.randint(1, 23)}\n"
                zm.write(cur_text)
                textForZmainy += cur_text
    
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")
    zm.write("\\.\n")
    textForZmainy += "\\.\n\n\n"
    all_data.write(textForZmainy)
            

# POPRAWNE ODPOWIEDZI
with open("data/poprawne_odpowiedzi.data", "w") as f:
    f.write("COPY poprawne_odpowiedzi FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY poprawne_odpowiedzi FROM STDIN DELIMITER ';' NULL 'null';\n")

    for turn in range(numberOfTournaments):
        for zesp in tournament_teams[turn]:
            for i in range(len(tourn_que[turn])):
                if(random.randint(0, 3) == 1):
                    f.write(f"{turn};{zesp};{i+1}\n")
                    all_data.write(f"{turn};{zesp};{i+1}\n")

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")

# TYPY KAR
with open("data/typy_kar.data", "w") as f:
    f.write("COPY typy_kar FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY typy_kar FROM STDIN DELIMITER ';' NULL 'null';\n")

    f.write("0;spoznienie\n")
    all_data.write("0;spoznienie\n")
    f.write("1;zle zachowanie\n")
    all_data.write("1;zle zachowanie\n")
    f.write("2;niesportywna gra\n")
    all_data.write("2;niesportywna gra\n")

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# KARY DLA ZESPOLOW
with open("data/kary_dla_zespolow.data", "w") as f:
    f.write("COPY kary_dla_zespolow FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY kary_dla_zespolow FROM STDIN DELIMITER ';' NULL 'null';\n")

    for turn in range(numberOfTournaments):
        for zesp in tournament_teams[turn]:
            if(random.choice(range(20)) == 13):
                s = f"{random.randint(0, 2)};{zesp};{turn}\n"
                f.write(s)
                all_data.write(s)

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# NAGRODY
with open("data/nagrody.data", "w") as f:
    f.write("COPY nagrody FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY nagrody FROM STDIN DELIMITER ';' NULL 'null';\n")

    f.write("0;peiniędzy\n")
    all_data.write("0;peiniędzy\n")
    f.write("1;bilety do kina\n")
    all_data.write("1;bilety do kina\n")
    f.write("2;nagroda od sponosorow\n")
    all_data.write("2;nagroda od sponosorow\n")
    
    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# NAGRODY W TURNIEJACH
with open("data/nagrody_w_turniejach.data", "w") as f:
    f.write("COPY nagrody_w_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY nagrody_w_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")

    for turn in range(numberOfTournaments):
        for i in range(3):
            s = f"{random.randint(0, 2)};{turn};{i+1}\n"
            f.write(s)
            all_data.write(s)

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")


# ORGANIZACJA
with open('data/organizacja.data', 'w') as f:
    f.write("COPY organizacja FROM STDIN DELIMITER ';' NULL 'null';\n")
    all_data.write("COPY organizacja FROM STDIN DELIMITER ';' NULL 'null';\n")

    f.write("0;31;UJ\n")
    all_data.write("0;31;UJ\n")
    f.write("1;30;UE\n")
    all_data.write("1;30;UE\n")

    f.write("\\.\n")
    all_data.write("\\.\n\n\n")