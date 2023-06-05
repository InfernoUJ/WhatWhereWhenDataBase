with open("pytania_na_turniejach.data", "w") as f:
    for i in range(36):
        f.write(f"0;{i+1};{i+1}\n")
    for i in range(14):
        f.write(f"1;{36+i+1};{i+1}\n")