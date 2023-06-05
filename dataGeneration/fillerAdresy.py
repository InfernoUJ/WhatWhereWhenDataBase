from faker import Faker
import random
import datetime


fake = Faker('pl_PL')


with open('data/adresy.data', 'w') as f:
    f.write("COPY adresy FROM STDIN DELIMITER ',' NULL 'null';\n")

    for i in range(20):
        f.write(f"{i},{fake.city()},{fake.street_name()},{fake.postcode()},{random.randint(1,40)},{random.randint(1, 100)}\n")
    
    f.write("\\.\n")