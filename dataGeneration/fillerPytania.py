from lorem_text import lorem
import random


with open('data/pytania.data', 'w') as f:
    f.write("COPY pytania FROM STDIN DELIMITER ';' NULL 'null';\n")

    for i in range(13, 701):
        f.write(f"{i};{lorem.words(random.randint(30,50))};{lorem.words(1)};{random.randint(0,10)}\n")

    f.write("\\.\n")