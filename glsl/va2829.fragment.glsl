#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pos = distance(-1.0+2.0*gl_FragCoord.xy, vec2(resolution.x*sin(time*0.05),resolution.y*cos(time*0.05)));	
	gl_FragColor = vec4( vec3(tan(pos)*.005*abs(sin(time*5.))), 1.0 );
}