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
	float d = distance(gl_FragCoord.xy/resolution.xy/vec2(resolution.y/resolution.x,1.0), mouse/vec2(resolution.y/resolution.x,1.0));
	if (d < 0.1) {
		c[0] = c[0] + 0.02/d;
	}
	
	gl_FragColor = vec4(c, 1.0);

}