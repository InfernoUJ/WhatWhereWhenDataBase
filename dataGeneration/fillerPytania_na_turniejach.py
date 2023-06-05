import random

que_tourn = [None]+[_ for _ in range(0, 700)]

que_to_choose = [i for i in range(1, 701)]
with open("data/pytania_na_turniejach.data", "w") as f:
    f.write("COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';\n")

    for j in range(10):
        for i in range(36):
            que = random.choice(list(que_to_choose))
            que_to_choose.remove(que)
            que_tourn[j*10 + i + 1] = que
            f.write(f"{j};{que};{i+1}\n")
    for j in range(10, 20):
        for i in range(24):
            que = random.choice(list(que_to_choose))
            que_to_choose.remove(que)
            que_tourn[j*10 + i + 1] = que
            f.write(f"{j};{que};{i+1}\n")
    
    f.write("\\.\n")