#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pos = 0.0;
float b   = 0.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );


	float a = 0.0;
	a = fract(sin(position.x) * sin(position.y));
	
	a += sin(-position.x * time * 100.0) / 0.5;
	
	// clp
	a*=normalize(a*a)*a;
	
	// speed it up
	a*=100.0;
	
	// make it blue
	b=0.9;
	
	a *= b;
	
	a+=fract(cos(position.y));
	
	
	gl_FragColor = vec4(a,a,a+b,1.0);
}