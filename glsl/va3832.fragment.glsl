#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float COUNT = 40.0;

//SpiderWeb by CuriousChettai@gmail.com
//Linux fix
// [06 Sept 12] Spyke - Added some simple mouse control

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	vec3 color = vec3(0);
	
	float vertColor = 0.0;
	for(float i=0.0; i<COUNT; i++){
		float t = time/10.0 + (i+0.3); 
		
		uPos.y += sin(-t+uPos.x*(mouse.x*10.0))*0.2;
		float xAmp = sin(-t+uPos.y*(mouse.y*10.0)+cos(t/1.0))*0.2;
		float value = (sin(uPos.y*10.0) + uPos.x*xAmp*100.0);
		
		float stripColor = 1.0/sqrt(abs(value))/20.0;
		
		vertColor += stripColor;
		
		color = vec3(vertColor*0.01, vertColor*0.1, vertColor);
	}
	
	color *= color.r+color.g+color.b;
	gl_FragColor = vec4(color, 1.0);
}