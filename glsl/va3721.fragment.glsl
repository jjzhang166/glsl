#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//FakeLighting by CuriousChettai@gmail.com

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	vec2 uMousePos = vec2(mouse.x*1.86, mouse.y);
	uMousePos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	vec2 point = vec2(0.0, 0.0); 
	float len = sqrt( (uPos.x-point.x)*(uPos.x-point.x) + (uPos.y-point.y)*(uPos.y-point.y) );
	
	float value = pow(cos(len), 20.0) * sin(len*50.0 - time)+1.0;	
	float valuePlus = pow(cos(len+0.01), 20.0) * sin((len+0.01)*50.0 -time)+1.0;
	float derivative = valuePlus - value;
	
	float mouseAngle = atan(uPos.y-uMousePos.y, uPos.x-uMousePos.x); 
	float pointAngle = abs(atan(uPos.y, uPos.x))*derivative; 	
	
	vec3 color = vec3(value/10.0, value/10.0, pow(cos(pointAngle-mouseAngle+2.0)*0.9, 3.0));
	gl_FragColor = vec4(color, 1.0);
}