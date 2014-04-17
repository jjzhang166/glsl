#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float COUNT = 1.0;

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	//uPos *= 1.5;

	uPos.x += 0.5;
	
	float y = uPos.y;
	
	float vertColor = 0.0;
	for(float i=0.0; i<COUNT; i++){
		float t = time + (i+0.3); 
		
	//	uPos.x += sin(-t+uPos.y*11.0+cos(t/1.0))*0.2 * cos(t+uPos.x*20.0)*0.2;
	//	uPos.y += sin(-t+uPos.x*10.0)*0.2 - t/20.0;
	
	//	uPos.x += dot(uPos.x , uPos.y ) * 8.;
	//	uPos.x = sin(uPos.x) ;
		uPos.x += sin(uPos.y + t) * 0.4;
		
		float stripColor = 1. /  uPos.x / 100.;
		//float stripColor = 1.;
		
		vertColor += abs(stripColor);
	}
	
	float temp = vertColor;//*(y-0.7);	
//	vec3 color = vec3(temp*0.9, temp*0.1, temp*0.1*abs(y-1.0)) * 0.7;	
	vec3 color = vec3(temp*0.9, temp*0.1, temp*0.1) ;	
	//color *= color.r+color.g+color.b;
	gl_FragColor = vec4(color, 1.0);
}