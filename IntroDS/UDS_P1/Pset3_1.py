import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from ggplot import *
import datetime
import random



def plot1(turnstile_weather):
    #print turnstile_weather[(turnstile_weather['rain'] == 1)]['ENTRIESn_hourly']
    plt.figure()
    turnstile_weather[(turnstile_weather['rain'] == 0)]['ENTRIESn_hourly'].hist(bins=150,facecolor='yellow')
    turnstile_weather[(turnstile_weather['rain'] == 1)]['ENTRIESn_hourly'].hist(bins=150,facecolor='blue')
    plt.xlabel('Entries Hourly')
    plt.ylabel('Frequency')
    plt.title('Histogram of number of entries hourly - rain\\no rain')
    plt.axis([0, 5000, 0, 50000])
    plt.legend(["No Rain","rain"])
    plt.plot()
    plt.show()


def plot2(turnstile_weather):
    #print turnstile_weather[(turnstile_weather['rain'] == 1)]['ENTRIESn_hourly']
    #plt.figure()
    #turnstile_weather[(turnstile_weather['rain'] == 0)]['ENTRIESn_hourly'].hist(bins=150,facecolor='yellow')
    #turnstile_weather[(turnstile_weather['rain'] == 1)]['ENTRIESn_hourly'].hist(bins=150,facecolor='blue')
    #turnstile_weather = turnstile_weather.head()
   # print turnstile_weather

    df= turnstile_weather[(turnstile_weather['rain'] == 0)]
    _totalR =  df.groupby('UNIT').ENTRIESn_hourly.sum()
    _totalR.sort(ascending=False)
    _totalR = _totalR.head(100)
    #print _totalR

    df= turnstile_weather[(turnstile_weather['rain'] == 1)]
    _totalNR = df.groupby('UNIT').ENTRIESn_hourly.sum()
    _totalNR =  pd.concat([_totalNR,_totalR], axis=1, join='inner')


    _totalNR.to_csv("aa.csv", sep=',')
    _totalNR = pd.read_csv("aa.csv")
    del _totalNR['ENTRIESn_hourly.1']

    a= _totalNR['UNIT']
    b = _totalNR['ENTRIESn_hourly']
    _totalNR =  pd.concat([a, b], axis=1)
    print _totalNR
    #print list(_totalNR.columns.values)
    #return


    #print _totalNR
    #_totalNR = _totalNR.drop(10, axis=1)
    #print _totalNR.columns[1]
    #_totalNR.drop(_totalNR.columns[1], axis=1)
    #print _totalNR

    #print list(_totalNR.columns.values)#type(_totalNR)

    n = _totalR.count()
    ind = np.arange(n)    # the x locations for the groups
    width = 0.35

    p1 = plt.bar(ind, _totalR,   width, color='blue')
    p2 = plt.bar(ind, _totalNR['ENTRIESn_hourly'],   width, color='yellow')
    plt.xticks(ind+width/2.,_totalR.index.tolist())
    plt.legend(["Rain","No Rain"])
    plt.xlabel('UNIT')
    plt.ylabel('Entries')
    plt.title('Top 15 busiest stations')

    #plt.plot()
    #plt.gcf().autofmt_xdate()
    plt.show()



if __name__ == '__main__':
    turnstile_weather = pd.read_csv("C:/git/UdacityDataAnalystNanoDegree/IntroDS/UDS_P1/data/turnstile_data_master_with_weather.csv")
    #entries_histogram(turnstile_weather)
    plot1(turnstile_weather)

    #df = pandas.read_csv("C:/git/Python/Python1/UDS_P1/data/hr_year.csv")
    #gg= ggplot(df, aes('yearID', 'HR')) + geom_point(color = 'red') + geom_line(color='red')
    #print gg

    # df4 = pandas.DataFrame({'a': np.random.randn(1000) + 1, 'b': np.random.randn(1000),'c': np.random.randn(1000) - 1}, columns=['a', 'b', 'c'])
    # plt.figure();
    # df4.plot(kind='hist', alpha=0.5)


