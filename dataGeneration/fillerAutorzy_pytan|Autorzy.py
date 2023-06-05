import random

l = [0 for _ in range(40)]
que = [_ for _ in range(1, 701)]
with open('data/autorzy_pytan.data', 'w') as f:
    f.write("COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(1, 701):
        id_autora = random.choice([i for i in range(30)]+[i for i in range(200,210)])
        que[i-1] = id_autora
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
