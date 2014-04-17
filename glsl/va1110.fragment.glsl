#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Cotton

void main( void ) {

	vec2 position = gl_FragCoord.xy * 0.2;
	
	float color = 0.0;
	color += sin(position.x - (tan(position.y)));
	color -= fract(position.y + fract(position.x));

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}