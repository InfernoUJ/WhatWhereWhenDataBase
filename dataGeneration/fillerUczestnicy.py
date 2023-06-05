from faker import Faker
import random
import datetime


fake = Faker('pl_PL')


start_date = datetime.date(1965, 1, 1)
end_date = datetime.date(2011, 12, 31)

with open('data/uczestnicy.data', 'w') as f:
    f.write("COPY uczestnicy FROM STDIN DELIMITER ';' NULL 'null';\n")
    
    for i in range(300):
        # Generate a random date between the start and end dates
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)

        # Format the date as a string in the format "YYYY-MM-DD"
        formatted_date = random_date.strftime('%Y-%m-%d')       
        
        f.write(f"{i};{fake.first_name()};{fake.last_name()};{random.choice(('M', 'F'))};{formatted_date}\n")
    
    f.write("\\.\n")