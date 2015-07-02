import pandas
import csv

def fix_turnstile_data(filenames):
    '''
    Filenames is a list of MTA Subway turnstile text files. A link to an example
    MTA Subway turnstile text file can be seen at the URL below:
    http://web.mta.info/developers/data/nyct/turnstile/turnstile_110507.txt
    
    As you can see, there are numerous data points included in each row of the
    a MTA Subway turnstile text file. 

    You want to write a function that will update each row in the text
    file so there is only one entry per row. A few examples below:
    A002,R051,02-00-00,05-28-11,00:00:00,REGULAR,003178521,001100739
    A002,R051,02-00-00,05-28-11,04:00:00,REGULAR,003178541,001100746
    A002,R051,02-00-00,05-28-11,08:00:00,REGULAR,003178559,001100775
    
    Write the updates to a different text file in the format of "updated_" + filename.
    For example:
        1) if you read in a text file called "turnstile_110521.txt"
        2) you should write the updated data to "updated_turnstile_110521.txt"

    The order of the fields should be preserved. Remember to read through the 
    Instructor Notes below for more details on the task.
    
    In addition, here is a CSV reader/writer introductory tutorial:
    http://goo.gl/HBbvyy
    
    You can see a sample of the turnstile text file that's passed into this function
    and the the corresponding updated file in the links below:
    
    Sample input file:
    https://www.dropbox.com/s/mpin5zv4hgrx244/turnstile_110528.txt
    Sample updated file:
    https://www.dropbox.com/s/074xbgio4c39b7h/solution_turnstile_110528.txt

    #    '''
    #for name in filenames:
        #print name
    #foo = pandas.read_csv(filename)
    #print (foo)



    writefilename = 'updated_'+filename

    fw = open('C:/git/Python/Python1/UDS_P1/data/'+writefilename , 'w')
    writer = csv.writer(fw)#, delimiter='', quotechar='',quoting=csv.QUOTE_NONE)

    with open('C:/git/Python/Python1/UDS_P1/data/'+filename, 'rb') as f:
        reader = csv.reader(f)
        for row in reader:
            writer.writerow(row[0:8])
            for i in range(7,len(row)-5,5):
                writer.writerow(row[0:3] + row[i+1:i+6])

if __name__ == '__main__':
    filename = "turnstile_110507.txt"
    fix_turnstile_data(filename )





    # writefilename = 'updated_'+filename
    #
    # fw = open('C:/git/Python/Python1/UDS_P1/data/'+writefilename , 'w')
    # writer = csv.writer(fw)#, delimiter='', quotechar='',quoting=csv.QUOTE_NONE)
    #
    # with open('C:/git/Python/Python1/UDS_P1/data/'+filename, 'rb') as f:
    #     reader = csv.reader(f)
    #     for row in reader:
    #         m = row[0]+','+row[1]+','+row[2]+','
    #         steps = [0,5,10,15,20,25,30,35]
    #         for x in steps:
    #             if (len(row)>=x+7):
    #                 m1 = m+row[x+3]+','+row[x+4]+','+row[x+5]+','+row[x+6]+','+row[x+7]
    #                 print m1
    #                 writer.writerows([m1.split()])