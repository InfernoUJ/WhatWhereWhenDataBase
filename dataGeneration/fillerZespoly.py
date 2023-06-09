from faker import Faker
import random
import datetime


fake = Faker('pl_PL')


start_date = datetime.date(1985, 1, 1)
end_date = datetime.date(2023, 1, 1)

with open('data/zespoly.data', 'w') as f:
    f.write("COPY zespoly FROM STDIN DELIMITER ';' NULL 'null';\n")
    
    for i in range(5,20):
        # Generate a random date between the start and end dates
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)

        # Format the date as a string in the format "YYYY-MM-DD"
        formatted_date = random_date.strftime('%Y-%m-%d')       
        data_likwidacji = "null"
        if(random.choice([i for i in range(20)]) == 13):
            time_between_dates = end_date - random_date
            days_between_dates = time_between_dates.days
            random_number_of_days = random.randrange(days_between_dates)
            data_likwidacji = random_date + datetime.timedelta(days=random_number_of_days)
            data_likwidacji = data_likwidacji.strftime('%Y-%m-%d')
        
        city = random.choice([_ for _ in range(1, 20)] + ['null']*3)

        f.write(f"{i};{fake.word().capitalize()+' '+fake.word()};{formatted_date};{data_likwidacji};{city}\n")
    
    f.write("\\.\n")
