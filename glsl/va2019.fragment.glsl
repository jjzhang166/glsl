#ifdef GL_ES
precision mediump float;
#endif

//Creates a red pulsating grid made out of math functions

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float random;

float patternGen(vec2 position){
	return sin(position.y)/cos(position.y) * sin(position.x)*cos(position.x);
}

void main( void ) {	
	vec2 position = gl_FragCoord.xy;
	vec4 pixel = vec4(0,0,0,0);
	
	float xDif = abs(position.x - resolution.x*0.5);
	float yDif = abs(position.y - resolution.y*0.5);
	float dist = sqrt(xDif*xDif + yDif*yDif);
		
	pixel.x=  clamp(patternGen(position),0.0,1.0);
	pixel.x*= 1.0-(dist/resolution.x)/(clamp(0.1 * sin(time),0.0,1.0));
	
	
	gl_FragColor = vec4(pixel.x,0.0,0.0,0.0);
}

