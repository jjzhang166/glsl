#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 crater(float r, float x, float y) {
    	float z = sqrt(r*r - x*x - y*y) * 2.5;

    	vec3 normal = normalize(vec3(x, y, z));
	
	return normal;
}

void main( void ) {
	vec2 center = resolution / 2.;
	vec2 pos = gl_FragCoord.xy - center;

	
	vec3 color = vec3(0.);

	
	color += crater(100.0, pos.x, pos.y);
	color = abs(color);
	
	
	gl_FragColor = vec4(color, 1.0);
}