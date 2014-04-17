#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float wave(float x, float t)
{
	float h = 0.0;
	
	h += sin( x * 1.0 + t * 1.0 ) * 1.0;
	h += sin( x * 2.5 + t * 1.2 ) * 0.6;
	h += sin( x * 4.6 + t * 1.8 ) * 0.3;
	h += sin( x * 6.1 + t * 2.3 ) * 0.1;
	
	h *= 0.5;
	
	return h;
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	pos *= 8.0;
	
	float t = time;

	float h = wave(pos.x, t);
	
	float v = pos.y - h;
	
	vec4 col = vec4(smoothstep(0.0, 1.0, v*1000.0));
	
	//col.b += d;
	
	gl_FragColor = vec4(col);

}