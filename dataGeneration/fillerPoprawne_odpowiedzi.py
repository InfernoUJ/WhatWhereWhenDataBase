import random
with open("poprawne_odpowiedzi.data", "w") as f:
    # tur 1
    for zesp in range(5):
        for pytanie in range(1, 37):
            if(random.randint(0, 1) == 1):
                f.write(f"0;{zesp};{pytanie}\n")
    # tur 2
    for zesp in range(5):
        for pytanie in range(1, 15):
            if(random.randint(0, 1) == 1):
                f.write(f"1;{zesp};{pytanie}\n")