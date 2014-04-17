#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 12
// ACID TRIP
// how long can you watch? asked by @hintz
// mellow version by mkjpboffi

void main(void)
{
	vec2 v = (gl_FragCoord.xy - resolution*0.5) / resolution.y;
	
	float r = 8.0*length(v)-time;

	gl_FragColor = vec4( cos(r*cos(time*0.001)), sin(r*sin(time*0.0005)), cos(r*cos(time*.009)), 1.0 );
	
}