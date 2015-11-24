# Project 6 - Data Visualization with D3.js


Final version can be found [here!](http://bl.ocks.org/dmenin/raw/d12a22521ad32cacc906).




##Summary

     These Visualizations aim to help students on the Intro to Machine Learning course from the Udacity's Data Analyst Nanodegree to work on their final project, which consists on building an algorithm to identify Enron Employees who may have committed fraud based on the public Enron financial and email dataset.
		
	 This First visualization shows a graph of e-mail communication between Enron employees on the period from 19/11/1998 to 21/06/2002. Each node represents an employee and the links between them indicate who many e-mail were sent between the nodes (to keep the visualization simple, I’m only displaying links with more than 50 e-mails).
	 This graph was chosen because it clearly shows the relationship between the nodes. You can very quick and easily spot meaningful information like, who are the Vice presidents or how many emails one person sent to another for example.
	 
	 The next group of visualizations allow some exploratory data analysis on the official dataset provided by the Udacity team to be made. Two bar chats were chosen because they clearly display the data's distribution allowing a reader to spot how differently POIs and non-POIS behave. The scatter plot was chosen because it is a great tool for showing relationship between two variables.
   


##Design  
      
	  The first graph is purely explanatory. The idea is to see how much people communicated between themelves during the period mentioned above.
      The next graphs allow some exploratory data analysis on a different dataset. The idea is to select one of the measures (like salary for example) and show one bar plot with the actual values and a second bar plot with the normalized values (z-score). Is is also possible to select a second measure and see a scatter plot between both of them. On all the plots, the colour identifies whether the person is a POI or not
      Design Changes:

    	1) Implemented feedback 1 by adding a global <div> tag to centre the visualization
		2) Implemented feedback 2 by adding a link to the glossary to explain what the measures are; Was also suggested that all 3 plots should be on the same line, which I tested but didn't like because the scatter plot is two narrow. The result can be seen bu running the code on the "past versions\v2" folder or checking the "feedback2-result.png" file. (http://bl.ocks.org/dmenin/raw/d12a22521ad32cacc906/)
		3) Added an explanatory view of the "email relationship" between employees. (http://bl.ocks.org/dmenin/raw/913540b03d9c43af15e7/)




##Feedback \ Versions

    - v1: First version submitted
    - v2: Feedback received:

> I really have nothing substantive to say about your visualization ... except the obvious: it's clever, well done (the standardization makes the distinctions between levels especially clear), and would have been a huge asset when I was doing that project.
> (One minor detail is that the graphs would look better front and center ... they are lower left on my screen, so I have to scroll a bit to see the top graphs fully (maybe some of the text below the graphs, some above, with the graphs centered). As I say, a minor issue.)
> Very nice work!


    - v3: feedback received:

> Hi there, I'm not familiar with the dataset, so it would've helped to have a glossary of what the measures represent. What is "Other"? What are "Deferral Payments"? Also, it might've been nice to have all three visualizations on one page; playing with the comparison, > I've found myself scrolling up and down to make different selections which was a bit annoying. Hope that helps - Lee

	- v4: Udacity reviewer's feedback (shortened):
	
> The visualization is very good and shows a lot of details. Unfortunately, it is as pure exploratory visualization as it can be. It allows reader to explore data set really well. But it doesn't explain anything on itself. 
		

##Resources

    - http://dimplejs.org/
    - http://dillinger.io/
    - https://github.com/PMSI-AlignAlytics/dimple/wiki
	- https://gist.github.com/
    - Several StackOverflow Posts
    - Special thanks to John Kiernander who helped me with the colouring http://stackoverflow.com/questions/33799829/changing-colors-on-dimple-js-scatter-plot/33801051
	- https://github.com/mbostock/d3/wiki/Force-Layout
	- http://www.cs.cmu.edu/~enron/
	- http://www.inf.ed.ac.uk/teaching/courses/tts/assessed/roles.txt