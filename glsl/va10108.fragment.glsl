#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

vec4 point( vec2 pos )
{
	return length(gl_FragCoord.xy - pos)<=10.0? vec4(0, 0.4, 1, 1): vec4(0,0,0,1);
}

void main( void ) {
	
	vec4 col;
	for(int i = 0 ; i < 40 ; i++ ) {
		col += point( vec2(i*10, i*10) );
	}
	gl_FragColor = col;
}