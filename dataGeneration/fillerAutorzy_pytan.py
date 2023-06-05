import random


with open('autorzy_pytan.data', 'w') as f:
    for i in range(1,51):
        f.write(f"{random.choice((1,7,16,19,24))};{i}\n")