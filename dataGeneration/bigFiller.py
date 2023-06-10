from faker import Faker
from lorem_text import lorem
import random
import datetime


fake = Faker('pl_PL')
start_date = datetime.date(1965, 1, 1)
end_date = datetime.date(2023, 6, 3)


# ADRESY
numberOfAddresses = random.randint(20, 40)
with open('data/adresy.data', 'w') as f:
    f.write("COPY adresy FROM STDIN DELIMITER ',' NULL 'null';\n")

    for i in range(numberOfAddresses):
        f.write(f"{i},{fake.city()},{fake.street_name()},{fake.postcode()},{random.randint(1,40)},{random.randint(1, 100)}\n")
    
    f.write("\\.\n")


# PYTANIA
numberOfQuestions = random.randint(3000, 4000)
with open('data/pytania.data', 'w') as f:
    f.write("COPY pytania FROM STDIN DELIMITER ';' NULL 'null';\n")

    for i in range(12, numberOfQuestions):
        f.write(f"{i};{lorem.words(random.randint(30,50))};{lorem.words(1)};{random.randint(0,10)}\n")

    f.write("\\.\n")


#UCZESTNICY
numberOfPlayers = random.randint(300, 400)
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


# AUTORZY
with open('data/autorzy.data', 'w') as f:
    f.write("COPY autor FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(30):
        f.write(f"{i};{l[i]}\n")
    for i in range(30, 40):
        f.write(f"{i+170};{l[i]}\n")
    f.write("\\.\n")


# TURNIEJE
numberOfTournaments = random.randint(20, 30)
datesOfTournaments = [None for _ in range(numberOfTournaments)]
with open('data/turnieje.data', 'w') as f:
    f.write("COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(numberOfTournaments):
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)
        datesOfTournaments[i] = random_date # !!!!!!!!!!!!
        formatted_date = random_date.strftime('%Y-%m-%d')    


        srandom_number_of_days = random.randint(1, 7)
        srandom_date = random_date + datetime.timedelta(days=srandom_number_of_days)
        sformatted_date = srandom_date.strftime('%Y-%m-%d')    

        
        f.write(f"{i};{fake.word()+' '+fake.word()};{lorem.words(5)};{formatted_date};{sformatted_date};{random.randint(0,4)}\n")

    f.write("\\.\n")


# PYTANIA NA TURNIEJACH
que_tourn = [None]+[_ for _ in range(0, numberOfQuestions)]
tourn_que = [list() for _ in range(numberOfTournaments)]
que_to_choose = [i for i in range(numberOfQuestions)]
with open("data/pytania_na_turniejach.data", "w") as f:
    f.write("COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")

    for j in range(10):
        for i in range(36):
            #print(que_to_choose, len(que_to_choose))
            print(j, i, len([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)]))
            que = random.choice([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)])
            que_tourn[que] = j
            tourn_que[j].append(que)
            que_to_choose.remove(que)
            f.write(f"{j};{que};{i+1}\n")
    print("\n\n")
    for j in range(10, numberOfTournaments):
        for i in range(24):
            print(j, i, len([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)]))
            que = random.choice([question for question in que_to_choose if datesOfTournaments[j] > playersBirthday[que_aut[question]] + datetime.timedelta(days=365*5)])
            que_tourn[que] = j
            tourn_que[j].append(que)
            que_to_choose.remove(que)
            f.write(f"{j};{que};{i+1}\n")
    
    f.write("\\.\n")


# SKLADY W ZESPOLACH
# ZMIANY
with (open('data/sklady_w_zespolach.data', 'w') as f, open('data/zmiany.data', 'w') as zm):
    f.write("COPY sklady_w_zespolach FROM STDIN DELIMITER ';' NULL 'null';\n")
    zm.write("COPY zmiany FROM STDIN DELIMITER ';' NULL 'null';\n")

    for turn in range(20):
        available_teams = [i for i in range(0, 20)]
        available_players = [i for i in range(0, 300)]
        for i in range(random.randint(6, 20)):
            team = random.choice(available_teams)
            available_teams.remove(team)

            #add capitan
            cap = None
            while(cap == None):
                cap = random.choice(available_players)
                for question in tourn_que[turn]:
                    if que_aut[question-1] == cap:
                        cap = None
                        continue

            available_players.remove(cap)
            f.write(f"{cap};{team};{turn};0\n")

            #add 5 players
            players = []
            for j in range(5):
                player = None
                while(player == None):
                    player = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question-1] == player:
                            player = None
                            continue

                available_players.remove(player)
                players.append(player)
                f.write(f"{player};{team};{turn};1\n")
            
            #add trener
            if(random.randint(0, 1) == 1):
                trener = None
                while(trener == None):
                    trener = random.choice(available_players)
                    for question in tourn_que[turn]:
                        if que_aut[question-1] == trener:
                            trener = None
                            continue

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
                        if que_aut[question-1] == zapas:
                            zapas = None
                            continue
                
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
            