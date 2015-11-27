var svg1 = dimple.newSvg("#chart1Container", 990, 400);


function MeasureSelected() {
  createPlot1();
}

function createPlot1() {
	var e = document.getElementById('measureSelection');
	var categoryVal = e.options[e.selectedIndex].value;
	var categoryText = e.options[e.selectedIndex].text;


	
	//clear all graphs
	svg1.selectAll('g').remove();


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
	
	//Updates the legend text ("POI"" instead on "1" for example)
	var myLegend = myChart.addLegend(500, 10, 380, 20, "right",mySeries);
	myLegend._getEntries = function () {
		var orderedValues = ["Not a POI", "POI", "PnPOI"];
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
	
	//manually set colours to avoid same category receiving different colour on the next graph
	myChart.assignColor("0", "rgb(139,172,195)");
	myChart.assignColor("1", "rgb(251,153,142)");	
	myChart.assignColor("2", "rgb(253,195,129)");
	myChart.draw(1000);
    });
	
}