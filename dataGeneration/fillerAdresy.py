from faker import Faker
import random
import datetime


fake = Faker('pl_PL')


with open('adresy.data', 'w') as f:
    for i in range(5):
        f.write(f"{i},{fake.city()},{fake.street_name()},{fake.postcode()},{random.randint(1,40)},{random.randint(1, 100)}\n")