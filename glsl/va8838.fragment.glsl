#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getTex(float id)	
{
	//return mod(time,id);
	
	if( mod(time,id) > .1 )
		return 1.;
	return 0.;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float id = gl_FragCoord.x + resolution.x * gl_FragCoord.y;
	float onePixH = 1. / resolution.x * resolution.y;
	float onePixV = onePixH * resolution.x;
	id /= resolution.x * resolution.y;
	
	float color = 
		getTex(id) +
		getTex(id + onePixH) + 
		getTex(id - onePixH) + 
		getTex(id + onePixV) + 
		getTex(id - onePixV) +
		
		getTex(id + onePixH + onePixV) + 
		getTex(id + onePixH - onePixV) + 
		getTex(id - onePixH + onePixV) + 
		getTex(id - onePixH - onePixV);
	color /= 9.;
	gl_FragColor = vec4( color );
}