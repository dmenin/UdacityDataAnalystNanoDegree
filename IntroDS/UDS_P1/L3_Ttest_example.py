import numpy
import scipy.stats
import pandas

def compare_averages(filename):
    """
    Performs a t-test on two sets of baseball data (left-handed and right-handed hitters).

    You will be given a csv file that has three columns.  A player's name, handedness (L for lefthanded or R for righthanded) and their
    career batting average (called 'avg'). You can look at the csv  file via the following link:
    https://www.dropbox.com/s/xcn0u2uxm8c4n6l/baseball_data.csv
    
    Write a function that will read that the csv file into a pandas data frame, and run Welch's t-test on the two cohorts defined by handedness.
    
    One cohort should be a data frame of right-handed batters. And the other cohort should be a data frame of left-handed batters.
    
    We have included the scipy.stats library to help you write or implement Welch's t-test:
    http://docs.scipy.org/doc/scipy/reference/stats.html
    
    With a significance level of 95%, if there is no difference
    between the two cohorts, return a tuple consisting of
    True, and then the tuple returned by scipy.stats.ttest.  
    
    If there is a difference, return a tuple consisting of
    False, and then the tuple returned by scipy.stats.ttest.
    
    For example, the tuple that you return may look like:
    (True, (9.93570222, 0.000023))
    """
    df = pandas.read_csv(filename)
    df_rh = df[df['handedness']=='R']
    df_lh = df[df['handedness']=='L']
    #ttest_ind(a, b[, axis, equal_var])	Calculates the T-test for the means of TWO INDEPENDENT samples of scores.
    result =  scipy.stats.ttest_ind(df_rh['avg'],df_lh['avg'])

    if result[1]<=0.5:
        return(False, result)
    else:
        return(True, result)


if __name__ == '__main__':
    print compare_averages("C:/git/Python/Python1/UDS_P1/data/baseball_data.csv")