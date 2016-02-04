# Project 6 - Data Visualization with D3.js


Final version can be found [here!](http://bl.ocks.org/dmenin/raw/97924f4c86232f7e3a84/).


##Summary

	On this project I wrote a story on the titanic data to demonstrate that, not only women were more likely to survive the Titanic Tragedy, but that there was a specific side of the boat where it the "women first" rule was  strictly being enforced so it was easier for them to get to a life boat
   


##Design  
      
	  There are 4 graphs on this story, all leading to the conclusion that women were more likely to survive the titanic tragedy and that there were one side of the ship that really enforced the "women first" rule

    	1) Graph 1 shows that men, regardless of class, had a low survival chance than woman. I chose a stack bar to display that because it seemed like a good option to visually separate 3 categories, with 2 values each;		
		2) The second graph analyses only women survival rate between classes. I chose to use a percentage stacked bar because I'm comparing percentages among two classes and also displaying the values as a second option for the user;
		3) The third graph shows the percentage of men on each boat, ordered by launch order and coloured by bot side. Is chose a bar chart because he size of the bar gives visual indication of main measure being plotted. Given the small size of the red bars we can easily conclude that not many men boarded from the port side of the boath
		4) The forth graph serves as an auxiliary to the previous, where I sum all the boats in one value. I chose a pie chart with series because I needed two show 2 values (men and women - the "pies") by two classes (port and starboard - the series) and it produces a good visualization. 


##Feedback \ Change Log

	1 – layout change on graph
	
		User on Udacity’s google group suggested that the Y axis legend on the percentage should match the report’s, so I changed it from being decimal point to whole numbers (change can be seen on the "feedback" folder).

	2 -   legend alignment 

		Co-worker suggested that the legends on all graph should be aligned. Only exception would be the bar chart because it is a wide chart and should use all space available (changes can be seen on the "feedback" folder).

	3– from reviewers feedback

		•	Reviewer asked to display what the survival rates actually were for first class men, all women and women from steerage. Otherwise, the reader has to calculate.
 
			Changed sentence:  
			"Men in First Class had no better than a one in three chance of surviving, so compared to women, even women from steerage, they fared poorly."

			To:
			“Men in First Class had no better than a one in three chance of surviving (34%), which is a very low survival rate, especially considering that women overall had a 73% survival rate. Even women for steerage had a higher chance of surviving than men (49%).”

		•	Reviewer pointed out that there is no information regarding how many men there were in first class versus women in first class
			
			Added Sentence:
			"The first class was composed of 323 passengers; 179  of those were male (56%) and 144 female (44%)"

	

##Resources

    - http://www.dailymail.co.uk/news/article-2225664/Titanic-safety-officer-Maurice-Clarkes-warning-needed-50-lifeboats-ignored-astonishing-cover-revealed-100-years.html
	- http://www.encyclopedia-titanica.org/titanic-survivors-list/
	- http://biostat.mc.vanderbilt.edu/wiki/Main/DataSets
	- http://www.icyousee.org/titanic.html