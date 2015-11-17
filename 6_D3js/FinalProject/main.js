var svg1 = dimple.newSvg("#chart1Container", 790, 300);

function switchData() {
  createBarPlot();
}

function createBarPlot() {
  var e = document.getElementById('metric');
  var categoryVal = e.options[e.selectedIndex].value;
  var categoryText = e.options[e.selectedIndex].text;
  svg1.selectAll('g').remove();
  if (categoryVal === "select"){
	  return false;
  }


  d3.csv("poi.csv", function (data) {
	  
	  data = data.filter(function(d){
		  if (categoryVal === "bonus") {
			  if (parseInt(d.bonus) <= 0){
				return false;
			   }
		  } else if (categoryVal === "salary") {
			  if (parseInt(d.salary) <= 0){
				return false;
			   }
		  } else if (categoryVal === "expenses") {
			  if (parseInt(d.expenses) <= 0){
				return false;
			   }
		  }      

		  return true;
		});
  
		
      var myChart = new dimple.chart(svg1, data);
	  
      var x = myChart.addCategoryAxis("x", "Index"); 
      myChart.addMeasureAxis("y", categoryVal);

	  
      var s = myChart.addSeries("poi", dimple.plot.bar);

      myChart.draw();
    });
}

