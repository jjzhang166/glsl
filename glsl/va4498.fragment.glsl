#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	bool valid[5];
	valid[0] = true;
	
	vec3 c = vec3(0.2, 0.2, 0.2);
	float d = distance(gl_FragCoord.xy, mouse);
	if (d < 30.0) {
		c[0] = c[0] + 1.0;
	}
	
	gl_FragColor = vec4(c, 1.0);

}