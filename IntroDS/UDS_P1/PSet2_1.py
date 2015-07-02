import pandas
import pandasql


def num_rainy_days(filename):
    '''
    You can see the weather data that we are passing in below:
    https://www.dropbox.com/s/7sf0yqc9ykpq3w8/weather_underground.csv
    '''
    weather_data = pandas.read_csv(filename)
    q = """
    select avg(mintempi) from weather_data where rain = 1 and mintempi>55;
    """
    q = """
    select * from weather_data;
    """
    rainy_days = pandasql.sqldf(q.lower(), locals())
    return rainy_days


if __name__ == '__main__':
    print "Hello, world!"
    filename = "C:/git/Python/Python1/UDS_P1/data/weather_underground.csv"
    rainy_days = num_rainy_days(filename)
    print rainy_days