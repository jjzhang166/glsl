#ifdef GL_ES
precision mediump float;
#endif
#define COUNT 6

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	position.x *= resolution.x/resolution.y;
	
	float LOWER = 0.15;
	float UPPER = 0.5;
	float VALUE = 1.0;	

	
	float len = length(position - 0.5);
	float off = 0.25;
	
	float final = 0.0;
	
	float st = 1.0;
//	st += sin(time)/2.0+0.5;
//	LOWER -= (sin(time)/2.0+0.5)*0.5;
//	UPPER += sin(time)/2.0+0.5;	
	
	
	
	final += smoothstep(UPPER*st, LOWER*st, len) * VALUE;
	
	
	/*
	st -= off;
	final += smoothstep(UPPER*st, LOWER*st, len) * VALUE;
	
	st -= off;
	final += smoothstep(UPPER*st, LOWER*st, len) * VALUE;
	*/
	
	
	//st += sin(time)*0.05;

	/*
	for (int i=0; i<COUNT; i++) {
		st *= 1.0 - 1.0/float(COUNT);
		//st += sin(time)*0.05;
		
		
		final += smoothstep(UPPER*st, LOWER*st, len) * VALUE;
	}*/
	
	gl_FragColor = vec4( vec3( final ), 1.0 );

}