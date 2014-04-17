#ifdef GL_ES
precision mediump float;
#endif
//basic brick texture as found in "Texturing and Modeling: a Procedural Approach" pg 39-41
uniform vec2 resolution;

float brickWidth = .25;
float brickHeight = .08;
float mortarThickness = .01;

float bmWidth = brickWidth + mortarThickness;
float bmHeight = brickHeight + mortarThickness;

float mwf = mortarThickness * .5 / bmWidth;
float mhf = mortarThickness * .5 / bmHeight;

vec3 Cbrick = vec3(.5,.15,.14);
vec3 Cmortar = vec3 (.5);

void main( void ) 
{	
	vec2 pos = ( gl_FragCoord.xy);
	
	float scoord = pos.x;
	float tcoord = pos.y;
	
	float ss = scoord / bmWidth;
	float tt = tcoord / bmHeight;
	
	if (mod(tt*.5,1.) > .5) ss += .5;
	
	ss = fract(ss);
	tt = fract(tt);
	
	float w = step(mwf, ss) - step(1. - mwf, ss);
	float h = step(mhf, tt) - step(1. - mhf, tt);
	
	vec3 color = mix(Cmortar, Cbrick, w*h);
	
	gl_FragColor = vec4( color, 1.0 );
}