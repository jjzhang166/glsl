#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p *= length(mouse - p);

	float color = 0.0;
	
	vec2 t = p*100000000.; 
	if( mod(t.x, 2.0) > 1. == mod(t.y, 2.0) > 1. )
		color = 1.; 
	else 
		color = 0.; 
	
	gl_FragColor = vec4( color, color,color, 1.0 );

}