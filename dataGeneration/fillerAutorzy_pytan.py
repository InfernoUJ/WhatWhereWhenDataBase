import random

l = [0 for _ in range(40)]
que_aut = [_ for _ in range(1, 701)]
with open('data/autorzy_pytan.data', 'w') as f:
    f.write("COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(1, 701):
        id_autora = random.choice([i for i in range(30)]+[i for i in range(200,210)])
        que_aut[i-1] = id_autora
        f.write(f"{id_autora};{i}\n")
        if(id_autora < 30):
            l[id_autora] += 1
        else:
            l[id_autora-170] += 1
    f.write("\\.\n")

with open('data/autorzy.data', 'w') as f:
    f.write("COPY autor FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(30):
        f.write(f"{i};{l[i]}\n")
    for i in range(30, 40):
        f.write(f"{i+170};{l[i]}\n")
    f.write("\\.\n")



""""""


que_tourn = [None]+[_ for _ in range(0, 700)]
tourn_que = [list() for _ in range(20)]
que_to_choose = [i for i in range(1, 701)]
with open("data/pytania_na_turniejach.data", "w") as f:
    f.write("COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")

    for j in range(10):
        for i in range(36):
            que = random.choice(list(que_to_choose))
            que_tourn[que] = j
            tourn_que[j].append(que)
            que_to_choose.remove(que)
            f.write(f"{j};{que};{i+1}\n")
    for j in range(10, 20):
        for i in range(24):
            que = random.choice(list(que_to_choose))
            que_tourn[que] = j
            tourn_que[j].append(que)
            que_to_choose.remove(que)
            f.write(f"{j};{que};{i+1}\n")
    
    f.write("\\.\n")


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
                print(turn, players)
                changed = random.choice(players)
                players.remove(changed)
                zm.write(f"{turn};{changed};{zap};{random.randint(1, 23)}\n")
    
    f.write("\\.\n")
    zm.write("\\.\n")
            