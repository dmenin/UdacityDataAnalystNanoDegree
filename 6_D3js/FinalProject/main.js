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
	
	//clear all graphs
	svg1.selectAll('g').remove();
	svg2.selectAll('g').remove();
	svg3.selectAll('g').remove();

	//do not print anything if category not selected
	if (categoryVal === "select"){ 
		return false;
	}

	d3.csv("poi.csv", function (data) {

	//remove zeros
	filtereddata = data.filter(function(d){
		if (parseInt(d[categoryVal]) == 0){
			return false;
		}		  
		  return true;
	});


	var myChart = new dimple.chart(svg1, filtereddata);	  
	var x = myChart.addCategoryAxis("x", "Index");   	  	
	x.title = "Person's Index"; 
	x._getFormat = function() { return ""; }; //clears the labels on the indexes
	var y = myChart.addMeasureAxis("y", categoryVal);
	y.title = categoryText;
	var mySeries = myChart.addSeries("poi", dimple.plot.bar);
	
	var myLegend = myChart.addLegend(350, 10, 380, 20, "right",mySeries);
	myLegend._getEntries = function () {
		var orderedValues = ["Not a POI", "POI"];
		var entries = [];
		orderedValues.forEach(function (v) {
        entries.push(
			{
                key: v,
                fill: myChart.getColor(v).fill,
                stroke: myChart.getColor(v).stroke,
                opacity: myChart.getColor(v).opacity,
                series: mySeries,
                aggField: [v]
            }
        );
		}, this);
  
    return entries;
	};	
	
	myChart.assignColor("0", "rgb(139,172,195)");
	myChart.assignColor("1", "rgb(251,153,142)");	
	myChart.draw(1000);

	
	categoryValNorm = categoryVal+"Norm"
	var myChart2 = new dimple.chart(svg2, filtereddata);	  
	var x = myChart2.addMeasureAxis("x", categoryValNorm); 
	x.title = categoryText + " Z-Score";
	var y = myChart2.addCategoryAxis("y", "Index");
	y.title = "Person's Index"; 
	y._getFormat = function() { return ""; }; //clears the labels on the indexes
	var mySeries2 = myChart2.addSeries("poi", dimple.plot.bar);
	myChart2.assignColor("0", "rgb(139,172,195)");
	myChart2.assignColor("1", "rgb(251,153,142)");	
	var myLegend2 = myChart2.addLegend(80, 10, 380, 20, "right",mySeries2);
	myLegend2._getEntries = myLegend._getEntries //use the same values generated on the first graph
	myChart2.draw(1000);

	
	if (categoryValCompare === "select"){
	  return false;
	}

	var myChart3 = new dimple.chart(svg3, data);
	var x3 = myChart3.addMeasureAxis("x", categoryVal); 
	x3.title = categoryText;
	
	var y3 = myChart3.addMeasureAxis("y", categoryValCompare);
	y3.title = categoryTextCompare;
	var mySeries3 = myChart3.addSeries(["Index","", "poi"], dimple.plot.scatter);
	myChart3.assignColor("0", "rgb(139,172,195)");
	myChart3.assignColor("1", "rgb(251,153,142)");	
	var myLegend3 = myChart3.addLegend(530, 10, 380, 20, "right",mySeries3);
	myLegend3._getEntries = myLegend._getEntries //use the same values generated on the first graph	
	myChart3.draw(1000);	

  
	  
    });
}

