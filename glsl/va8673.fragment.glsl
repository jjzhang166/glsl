#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 function(vec2 p) {
	float x =p.x;
	float y =p.y;
	vec2 r = 1.0 + 5.933 * p -43.2 * p*p + 74.667 * p*p*p -38.4 * p*p*p*p;
	float v =  .5 + .233 * y -7.133 * y*y + 13.867 * y*y*y -7.467 * y*y*y*y;
	
	return vec4(length(r), v, .0,1.0);
}

void main( void )
{
	
	vec2 position = gl_FragCoord.xy /  resolution;

	
	gl_FragColor = function (position);
}