#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void random(in float rn1, in float rn2, out float rn3)
{
	fract(sin(gl_FragCoord.x * 12.9898 + gl_FragCoord.y * 78.233 + time) * 43758.5453); 
}

void main( void ) {

	float rn1 = gl_FragCoord.x;
	float rn2 = gl_FragCoord.y;
	float rn3 = 1.0;
	random(rn1, rn2, rn3);
	
	gl_FragColor = vec4(rn3, rn3, rn3, 1);
}