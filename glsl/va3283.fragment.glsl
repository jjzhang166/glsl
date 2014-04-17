01	var circleRadius = 0, spiralRadius = 0, angle = 0;
02	var numberOfCircles = 100;
03	 
04	for(var i = 0; i < numberOfCircles; i++){
05	     
06	    angle++;
07	    spiralRadius += 2;
08	    circleRadius += 0.2;
09	     
10	    var x = (document.size.width / 2) + Math.cos(angle) * spiralRadius;
11	    var y = (document.size.height / 2) + Math.sin(angle) * spiralRadius;
12	     
13	    createCircle(x, y, circleRadius);
14	}
15	 
16	function createCircle(x, y, radius){
17	         
18	    var circle = new Path.Circle(new Point(x, y), radius){
19	        fillColor:"#5CC4BE"
20	    };
21	}
22	 
23	function randomNumber(min, max){
24	    return min + Math.random() * (max - min);
25	}