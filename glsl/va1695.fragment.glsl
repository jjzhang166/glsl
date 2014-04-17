#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float rand(vec2 co){  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ); 

	float color = 0.0;
	
	vec2 t = p*8.; 
	if( mod(t.x + rand(p / sin(time)) / 50., 2.0) > 1. == mod(t.y + rand(p * sin(time)) / 50., 2.0) > 1. )
		color = 1.; 
	else 
		color = 0.; 
	
	gl_FragColor = vec4( color, color,color, 1.0 );

}