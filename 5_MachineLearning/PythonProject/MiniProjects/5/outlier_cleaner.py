def outlierCleaner(predictions, ages, net_worths):
    """
        clean away the 10% of points that have the largest
        residual errors (different between the prediction
        and the actual net worth)

        return a list of tuples named cleaned_data where 
        each tuple is of the form (age, net_worth, error)
    """

    # ages =  ages[0:3]
    # net_worths =  net_worths[0:3]
    # predictions =  predictions[0:3]
    # print ages
    # print net_worths
    # print predictions

    errors = (net_worths-predictions)**2

    zipped = zip(ages,net_worths,errors)
    less_data = sorted(zipped, key = lambda tup: tup[2])
    less_data = less_data[:80]

    return less_data
