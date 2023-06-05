from faker import Faker
import random
import datetime


fake = Faker('pl_PL')


start_date = datetime.date(1965, 1, 1)
end_date = datetime.date(2011, 12, 31)

with open('autor.data', 'w') as f:
    for i in range(5):
        f.write(f"{random.randint(0, 30)} {random.randint(0, 10)}\n")