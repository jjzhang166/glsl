#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += sin(5.0*time*(tan(position.y/1.0))*1.0);
	color += sin(5.0*time*(tan(position.x/1.0))*1.0);

	gl_FragColor = vec4( vec3(sqrt(color) ,0.0/color ,0.0 ), 1.0 );

}