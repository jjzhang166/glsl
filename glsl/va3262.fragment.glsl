#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;


float fade_in( float start, float duration)
{
	if(time >= start)
		return smoothstep(start,start+duration,  time);
	else
		return 0.0;

}

float fade_out( float start, float duration)
{
	if(time >= start)
		return 1.0 - smoothstep(start,start+duration,  time);
	else
		return 1.0;

}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec3 clr = vec3(1.0);
	clr *= fade_in( 4.0, 6.0);
	gl_FragColor = vec4( clr, 1.0 );

}