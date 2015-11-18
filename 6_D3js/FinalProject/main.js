var svg1 = dimple.newSvg("#chart1Container", 790, 400);
var svg2 = dimple.newSvg("#chart2Container", 490, 400);
var svg3 = dimple.newSvg("#chart3Container", 1000, 500);


function MeasureSelected() {
  createPlot1();
}

function createPlot1() {
	var e = document.getElementById('measureSelection');
	var categoryVal = e.options[e.selectedIndex].value;
	var categoryText = e.options[e.selectedIndex].text;

	var ec = document.getElementById('measureCompareToSelection');
	var categoryValCompare = ec.options[ec.selectedIndex].value;
	var categoryTextCompare = ec.options[ec.selectedIndex].text;

	svg1.selectAll('g').remove();
	svg2.selectAll('g').remove();
	svg3.selectAll('g').remove();


	if (categoryVal === "select"){
	return false;
	}



	var canvas_width = 800;
	var canvas_height = 400;
	var padding = 50;  // for chart edges	  

	var margin = 75,
	width = 600 - margin,
	height = 300 - margin;

	d3.csv("poi.csv", function (data) {


	filtereddata = data.filter(function(d){

	if (parseInt(d[categoryVal]) == 0){
		return false;
	}		  

	  return true;
	});

	var count_extent = d3.extent(data, function(d) {
	  return d[categoryVal];
	});		


	var myChart = new dimple.chart(svg1, filtereddata);	  
	var x = myChart.addCategoryAxis("x", "Index");   	  	
	x.title = ""; //no title on index
	x._getFormat = function() { return ""; }; //clears the labels on the indexes
	var y = myChart.addMeasureAxis("y", categoryVal);
	y.title = categoryText;
	var mySeries = myChart.addSeries("poi", dimple.plot.bar);
	myChart.addLegend(200, 10, 380, 20, "right");
	
	myChart.draw();

	categoryValNorm = categoryVal+"Norm"
	var myChart2 = new dimple.chart(svg2, filtereddata);	  
	var x = myChart2.addMeasureAxis("x", categoryValNorm); 
	x.title = categoryText + " Z-Score";
	var y = myChart2.addCategoryAxis("y", "Index");
	y.title = "";
	y._getFormat = function() { return ""; }; //clears the labels on the indexes
	myChart2.addSeries("poi", dimple.plot.bar);
	myChart2.draw();

	//var myChart4 = new dimple.chart(svg4, data);
	//myChart4.addMeasureAxis("x", categoryVal); 	
	//myChart4.draw();
	
	
	if (categoryValCompare === "select"){
	  return false;
	}

	var myChart3 = new dimple.chart(svg3, data);
	myChart3.addCategoryAxis("x", categoryVal); 
	myChart3.addCategoryAxis("y", categoryValCompare);			
	myChart3.addSeries("poi", dimple.plot.bubble);
	myChart3.draw();



			

			



	  
	  
    });
}

