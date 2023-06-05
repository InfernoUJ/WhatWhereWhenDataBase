from faker import Faker
import random
import datetime


fake = Faker('pl_PL')


start_date = datetime.date(1985, 1, 1)
end_date = datetime.date(2023, 1, 1)

with open('uczestnicy.data', 'w') as f:
    for i in range(5):
        # Generate a random date between the start and end dates
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)

        # Format the date as a string in the format "YYYY-MM-DD"
        formatted_date = random_date.strftime('%Y-%m-%d')       
        print(formatted_date)
        