def outlierCleaner(predictions, ages, net_worths):
    """
        clean away the 10% of points that have the largest
        residual errors (different between the prediction
        and the actual net worth)

        return a list of tuples named cleaned_data where 
        each tuple is of the form (age, net_worth, error)
    """
    
    cleaned_data = []

    ages =  ages[0:1]
    net_worths =  net_worths[0:1]
    predictions =  predictions[0:1]

    # print ages
    # print net_worths
    # print predictions


    errors = (net_worths-predictions)**2
    cleaned_data = zip(ages,net_worths,errors)

    #??

    cleaned_data = sorted(cleaned_data,key=lambda x:x[2][0],reverse=True)
    print cleaned_data
    #limit = int(len(net_worths)*0.1)

    #return cleaned_data[limit:]

    ### your code goes here

    
    return cleaned_data