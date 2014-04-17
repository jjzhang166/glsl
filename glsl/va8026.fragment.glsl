#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592
#define PI2 PI * 2.

float line(vec2 pt, float a)
{
	return pt.x > a
		? 1. : 0.;
}

float circle(vec2 pt, vec2 pos, float r)
{
	return length(pos-pt) < r ? 1. : 0.;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.y );
	position.x = position.x-.5;
	
	float color = line(position, .5 - sin(position.y * PI2 * 2.) / 10.);
	if(length(position - .5) > .25)
		color = -1.;
	color = color == -1. ? .05 : color;
	color = max(circle(vec2(.5, .375), position, .04), color);
	color = min(1.-circle(vec2(.5, .625), position, .04), color);
	gl_FragColor = vec4( color );

}