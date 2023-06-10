from faker import Faker
from lorem_text import lorem
import random
import datetime


fake = Faker('pl_PL')
start_date = datetime.date(1965, 1, 1)
end_date = datetime.date(2023, 6, 3)

# CITIES
numberOfCities = random.randint(10, 20)
cities = [None for _ in range(numberOfCities)]
with open('data/miejscowosci.data', 'w') as f:
    f.write("COPY miejscowosci FROM STDIN DELIMITER ',' NULL 'null';\n")
    for i in range(numberOfCities):
        cities[i] = fake.city()
        f.write(f"{i},{cities[i]}\n")
    f.write("\\.\n")

# ADRESY
numberOfAddresses = random.randint(20, 40)
with open('data/adresy.data', 'w') as f:
    f.write("COPY adresy FROM STDIN DELIMITER ',' NULL 'null';\n")

    for i in range(numberOfAddresses):
        f.write(f"{i},{random.randint(0, numberOfCities-1)},{fake.street_name()},{fake.postcode()},{random.randint(1,40)},{random.randint(1, 100)}\n")
    
    f.write("\\.\n")


# PYTANIA
numberOfQuestions = random.randint(3000, 4000)
with open('data/pytania.data', 'w') as f:
    f.write("COPY pytania FROM STDIN DELIMITER ';' NULL 'null';\n")

    for i in range(12, numberOfQuestions):
        f.write(f"{i};{lorem.words(random.randint(30,50))};{lorem.words(1)};{random.randint(0,10)}\n")

    f.write("\\.\n")


#UCZESTNICY
numberOfPlayers = random.randint(800, 1200)
playersBirthday = [None for _ in range(numberOfPlayers)]
with open('data/uczestnicy.data', 'w') as f:
    f.write("COPY uczestnicy FROM STDIN DELIMITER ';' NULL 'null';\n")
    
    for i in range(numberOfPlayers):
        # Generate a random date between the start and end dates
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)

        playersBirthday[i] = random_date

        # Format the date as a string in the format "YYYY-MM-DD"
        formatted_date = random_date.strftime('%Y-%m-%d')       
        
        f.write(f"{i};{fake.first_name()};{fake.last_name()};{random.choice(('M', 'F'))};{formatted_date}\n")
    
    f.write("\\.\n")


# AUTORZY PYTAN
autors = set()
l = [0 for _ in range(40)] # number of questions for each author
que_aut = [None for _ in range(numberOfQuestions)]
with open('data/autorzy_pytan.data', 'w') as f:
    f.write("COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(numberOfQuestions):
        id_autora = random.choice([i for i in range(30)]+[i for i in range(200,210)])
        autors.add(id_autora)
        que_aut[i] = id_autora
        f.write(f"{id_autora};{i}\n")
        if(id_autora < 30):
            l[id_autora] += 1
        else:
            l[id_autora-170] += 1
    f.write("\\.\n")

for a in autors:
    print(a, playersBirthday[a])

# AUTORZY
with open('data/autorzy.data', 'w') as f:
    f.write("COPY autor FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(30):
        f.write(f"{i};{l[i]}\n")
    for i in range(30, 40):
        f.write(f"{i+170};{l[i]}\n")
    f.write("\\.\n")


# TURNIEJE
start_date_tourn = datetime.date(1980, 1, 1)
numberOfTournaments = random.randint(20, 30)
datesOfTournaments = [None for _ in range(numberOfTournaments)]
endsOfTournaments = [None for _ in range(numberOfTournaments)]
with open('data/turnieje.data', 'w') as f:
    f.write("COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';\n")
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
        
        f.write(f"{i};{fake.word()+' '+fake.word()};{lorem.words(5)};{formatted_date};{sformatted_date};{random.randint(0,4)}\n")

    f.write("\\.\n")

for i, t in enumerate(datesOfTournaments):
    print(i, t)

# PYTANIA NA TURNIEJACH
que_tourn = [None]+[_ for _ in range(0, numberOfQuestions)]
tourn_que = [list() for _ in range(numberOfTournaments)]
que_to_choose = [i for i in range(numberOfQuestions)]
with open("data/pytania_na_turniejach.data", "w") as f:
    f.write("COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")

    for j in range(numberOfTournaments):
        for i in range(24):
            #print(j, i, len([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)]))
            que = random.choice([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)])
            que_tourn[que] = j
            tourn_que[j].append(que)
            que_to_choose.remove(que)
            f.write(f"{j};{que};{i+1}\n")
    
    f.write("\\.\n")


# ZESPOLY
numberOfTeams = random.randint(numberOfTournaments, numberOfTournaments*3)
teamsDateOfCreation = [None for _ in range(numberOfTeams)]
teamsDateOfCreation[0] = datetime.date(2000,2,25)
teamsDateOfCreation[1] = datetime.date(2018,4,20)
teamsDateOfCreation[2] = datetime.date(2010,3,17)
teamsDateOfCreation[3] = datetime.date(2015,11,11)
teamsDateOfCreation[4] = datetime.date(1990,2,28)

with open('data/zespoly.data', 'w') as f:
    f.write("COPY zespoly FROM STDIN DELIMITER ';' NULL 'null';\n")
    
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
            data_likwidacji = data_likwidacji.strftime('%Y-%m-%d')
        
        city = random.choice([i for i in range(numberOfCities)] + ['null']*3)

        f.write(f"{i};{fake.word().capitalize()+' '+fake.word()};{formatted_date};{data_likwidacji};{city}\n")
    
    f.write("\\.\n")


# SKLADY W ZESPOLACH
# ZMIANY

def checkIfTimesIntersects(player, tourn, playersInTournaments, datesOfTournaments, endsOfTournaments):
    if len(playersInTournaments[player]) == 0:
        return False
    
    for start, end in playersInTournaments[player]:
        if (datesOfTournaments[tourn] <= start <= endsOfTournaments[tourn] 
           or datesOfTournaments[tourn] <= end <= endsOfTournaments[tourn]):
            return True
    return False

playersInTournaments = [[] for _ in range(numberOfPlayers)]
tournament_teams = [[] for _ in range(numberOfTournaments)]
with (open('data/sklady_w_zespolach.data', 'w') as f, open('data/zmiany.data', 'w') as zm):
    f.write("COPY sklady_w_zespolach FROM STDIN DELIMITER ';' NULL 'null';\n")
    zm.write("COPY zmiany FROM STDIN DELIMITER ';' NULL 'null';\n")

    for turn in range(numberOfTournaments):
        available_teams = [i for i in range(numberOfTeams) if teamsDateOfCreation[i] <= datesOfTournaments[turn]]
        available_players = [i for i in range(numberOfPlayers) 
                             if playersBirthday[i] <= datesOfTournaments[turn] - datetime.timedelta(days=365*5) 
                                and i not in [que_aut[que] for que in tourn_que[turn]]
                                and not checkIfTimesIntersects(i, turn, playersInTournaments, datesOfTournaments, endsOfTournaments)]
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
                        continue
            
            playersInTournaments[cap].append((datesOfTournaments[turn], endsOfTournaments[turn]))
            available_players.remove(cap)
            f.write(f"{cap};{team};{turn};0\n")

            #add 5 players
            players = []
            for j in range(5):
                player = None
                while(player == None):
                    player = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question] == player:
                            player = None
                            continue
                
                playersInTournaments[player].append((datesOfTournaments[turn], endsOfTournaments[turn]))
                available_players.remove(player)
                players.append(player)
                f.write(f"{player};{team};{turn};1\n")
            
            #add trener
            if(random.randint(0, 1) == 1):
                trener = None
                while(trener == None):
                    trener = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question] == trener:
                            trener = None
                            continue
                
                playersInTournaments[trener].append((datesOfTournaments[turn], endsOfTournaments[turn]))
                available_players.remove(trener)
                f.write(f"{trener};{team};{turn};2\n")
            
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
                            continue
                
                playersInTournaments[zapas].append((datesOfTournaments[turn], endsOfTournaments[turn]))
                zapas_players.append(zapas)
                available_players.remove(zapas)
                f.write(f"{zapas};{team};{turn};3\n")

            #add zmiany
            for zap in zapas_players:
                #print(turn, players)
                changed = random.choice(players)
                players.remove(changed)
                zm.write(f"{turn};{changed};{zap};{random.randint(1, 23)}\n")
    
    f.write("\\.\n")
    zm.write("\\.\n")
            

# POPRAWNE ODPOWIEDZI
with open("data/poprawne_odpowiedzi.data", "w") as f:
    f.write("COPY poprawne_odpowiedzi FROM STDIN DELIMITER ';' NULL 'null';")

    for turn in range(numberOfTournaments):
        for zesp in tournament_teams[turn]:
            for i in range(len(tourn_que[turn])):
                if(random.randint(0, 2) == 1):
                    f.write(f"{turn};{zesp};{i+1}\n")

    f.write("\\.\n")
