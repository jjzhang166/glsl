#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Cotton

void main( void ) {

	vec2 position = (gl_FragCoord.xy +mouse * 1000.) * 0.01;
	
	float color = 0.0;
	color += sin(position.x+ time - cos(position.y));
	color -= fract(position.y - cos(position.x));

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}