#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {
	
	float alas = sin(gl_FragCoord.y + 50.0);
	float sivulle = cos(gl_FragCoord.x + 50.0)+time;
	float run = cos(gl_FragCoord.x +(0.2 * time));
	float run2 = cos(gl_FragCoord.y +(0.2 * time));
	gl_FragColor = vec4(sivulle/run,0.2,0.2,0.5);
	

	gl_FragColor = vec4(alas/run2,0.7,0.2,1.0);
}

