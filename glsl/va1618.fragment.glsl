#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool square(vec2 p, vec2 c, float sl) {
	float r = sl / 2.0;
	float xm = c.x - r;
	float xx = c.x + r;
	float ym = c.y - r;
	float yx = c.y + r;
	
	return (p.x > xm
	    && p.x < xx
		&& p.y > ym
		&& p.y < yx);
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x / resolution.y;
	uv.y /= aspect;
	
	vec3 color = vec3(0.0);
	
	if (square(uv, vec2(0.5, 0.25), 0.1)) {
		color = vec3(1.0);
	}
	    
	gl_FragColor = vec4(color, 1.0);
}