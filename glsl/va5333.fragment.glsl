#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec4 hoge = vec4(1,1,1,1);
	if(hoge*4.0==hoge*vec4(4,4,4,4))
	{
		gl_FragColor = vec4( 0.7, 0.0, 0.0, 0.0 );
	}
	else
	{
		gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	}
}