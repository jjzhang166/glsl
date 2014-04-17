#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	vec2 uv = pos;
	pos-=.5;
	pos*=2.;
	vec4 col;
	
	
	
	col.a = 1.;
	gl_FragColor = col;

}