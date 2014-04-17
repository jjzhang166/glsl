#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += pow(position.y, 10.0);
	
	for(int i = 0; i < 3; i ++) {
		color += sin(position.x)+sin(position.y)*sin(time*0.005)*cos(time*0.005);
		//color *= sin(time);

	}


	gl_FragColor = vec4( vec3( color, color * 0.5, 0.75 ), 1.0 );

}