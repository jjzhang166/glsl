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
	//gl_FragColor = vec4(0.4, 0.3, 0.0, 1.0);
	//gl_FragColor = point( vec2(100.0, 500.0) );
	
	vec4 col;
	for(int i = 0 ; i < 100 ; i++ ) {
		col += point( vec2(i*10, i*10) );
	}
	gl_FragColor = col;
}