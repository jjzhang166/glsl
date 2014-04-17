#ifdef GL_ES
precision mediump float;
#endif
#define NUMBER_OF_POINTS 80
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pi=3.14159265359;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	int pointIndex=0;
	vec2 points[NUMBER_OF_POINTS];
	float xValue=0.0;
	float thresh=0.1;
	int intersections=0;
	for(int i=0;i<NUMBER_OF_POINTS;i++){
		xValue+=1.0;
		float sinValue=(xValue/(2.0*pi))+sin(time);
		points[i]=vec2(xValue/80.0,sin(sinValue)/4.0 +0.5);
	}
	float distanceToPoint[NUMBER_OF_POINTS];
	float minDistance=10000000.0;
	for(int i=0;i<NUMBER_OF_POINTS;i++){
		distanceToPoint[i]=distance(position,points[i]);
		if(distanceToPoint[i]<0.01){
			//color.r=1.0;
			color.g=1.0;
		}
		if(distanceToPoint[i]<minDistance){
			pointIndex=i;
			minDistance=distanceToPoint[i];
		}
	}
		
	for(int j=0;j<NUMBER_OF_POINTS;j++){			
		if( ( distanceToPoint[j]-minDistance)<thresh){
			intersections++;
		}
		
	}
	if(intersections>=10){
		color.b=1.0;
	}
	color.r=sin(float(pointIndex));
	
	//	color=value;
	
	
	gl_FragColor = color;

}