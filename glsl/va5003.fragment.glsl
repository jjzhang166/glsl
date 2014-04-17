#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	float color = 10.0;
	
	float dist = length(uPos - vec2(0.05, 0.1));
	
	gl_FragColor = vec4( vec3( 1.0/pow(dist*3.0+0.9, 10.0)), 1.0 );
}