#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	float color = 0.0;
	
	float d = distance(position, vec2(0.5, 0.5));
	
	color = sin(d*3.14*50.0-time);
	
	int x = int(position.x - resolution.x/2.0);
	int y = int(position.y - resolution.y/2.0);
	
	int t = int(time);
	
	//color = x == int((0.5+0.5*sin(3.14*time))*resolution.x/2.0) ? 1.0 : 0.0;
	

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	gl_FragColor = vec4(color*vec3(1.0,1.0,1.0), 1.0);

}