from lorem_text import lorem
import random


with open('pytania.data', 'a') as f:
    for i in range(13, 51):
        f.write(f"{i};{lorem.words(random.randint(30,50))};{lorem.words(1)};{random.randint(0,10)}\n")