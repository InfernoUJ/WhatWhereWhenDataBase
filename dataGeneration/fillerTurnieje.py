from lorem_text import lorem
import random
import datetime
import faker

fake = faker.Faker('pl_PL')
start_date = datetime.date(1965, 1, 1)
end_date = datetime.date(2023, 6, 3)

with open('data/turnieje.data', 'a') as f:
    f.write("COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';\n")
    for i in range(20):
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)
        formatted_date = random_date.strftime('%Y-%m-%d')    

        stime_between_dates = end_date - random_date
        sdays_between_dates = stime_between_dates.days
        srandom_number_of_days = random.randrange(sdays_between_dates)
        srandom_date = start_date + datetime.timedelta(days=srandom_number_of_days)
        sformatted_date = srandom_date.strftime('%Y-%m-%d')    

        f.write(f"{i};{fake.word()+' '+fake.word()};{lorem.words(5)};{formatted_date};{sformatted_date};{random.randint(0,4)}\n")

    f.write("\\.\n")
    # time_between_dates = end_date - start_date
    # days_between_dates = time_between_dates.days
    # random_number_of_days = random.randrange(days_between_dates)
    # random_date = start_date + datetime.timedelta(days=random_number_of_days)
    # formatted_date = random_date.strftime('%Y-%m-%d')    

    # stime_between_dates = end_date - random_date
    # sdays_between_dates = stime_between_dates.days
    # srandom_number_of_days = random.randrange(sdays_between_dates)
    # srandom_date = start_date + datetime.timedelta(days=srandom_number_of_days)
    # sformatted_date = srandom_date.strftime('%Y-%m-%d')    

    # f.write(f"1;Mistrzostwa Polski;{lorem.words(5)};{formatted_date};{sformatted_date};{random.randint(0,4)}\n")