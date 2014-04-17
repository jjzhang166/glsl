#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0;
	
	vec3 mRGB = vec3(0.7, 0.7, 0.8);

	float color = 0.0;
	color += sin( position.y * sin( time / 20.0 ) * 40.0 ) + cos( position.x * sin( time / 40.0 ) * 40.0 );
	color += sin( position.x * 10.0 ) + sin( position.y * 80.0 );
	color = clamp(color, 0.0, 1.0);


	gl_FragColor = vec4( mRGB * color, 1.0);

}