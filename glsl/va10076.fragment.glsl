#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

vec4 point( vec2 pos )
{
	float s =  1.0 / length(gl_FragCoord.xy - pos);
	return vec4(0, s*0.4, s, 0.0);
}

void main( void ) {
	
	vec4 col;
	int t = int(time*10.0);
	for(int i = 0 ; i < 40 ; i++ ) {
		col += point( vec2(i*10, i*10) );
	}
	gl_FragColor = col;
}