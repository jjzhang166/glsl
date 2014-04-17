#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	float ar = resolution.y/resolution.x;
	float color = 0.0;

	int d = int(pow(pow(position.x-0.5, 2.0) + pow(position.y-0.5, 2.0) ,sin(time*0.1))*100.0);
	float m = 2.0;
	float q = mod(float(d), m);
	
	color = q;
	gl_FragColor = vec4( vec3(color) , 1.0 );

}
