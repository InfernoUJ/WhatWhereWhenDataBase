import random;
from copy import deepcopy
with (open('uczestnicy.data', 'r') as uczestnicy, open('turnieje.data', 'r') as turnieje, 
      open('sklady_w_zespolach.data', 'w') as f, open('zespoly.data', 'r') as zespoly):

    zespoly = zespoly.readlines()
    uczestnicy = uczestnicy.readlines()
    t = turnieje.readlines()
    for tur in t:
        u = deepcopy(uczestnicy)
        z = deepcopy(zespoly)
        for zesp in z:
            #choose capitan
            capitan = random.choice(u)
            u.remove(capitan)
            f.write(f"{capitan.split(';')[0]};{zesp.split(';')[0]};{tur.split(';')[0]};0\n")

            #choose players(5)
            for i in range(5):
                player = random.choice(u)
                u.remove(player)
                f.write(f"{player.split(';')[0]};{zesp.split(';')[0]};{tur.split(';')[0]};1\n")
            
            # #choose trener
            # trener = random.choice(u)
            # u.remove(trener)
            # f.write(f"{trener.split(';')[0]};{zesp.split(':')[0]};{tur.split(';')[0]};2")

            # #choose extra player(max 2)
            # for i in range(random.randint(1,2)):
            #     extra_player = random.choice(u)
            #     u.remove(extra_player)
            #     f.write(f"{extra_player.split(';')[0]};{zesp.split(':')[0]};{tur.split(';')[0]};3")