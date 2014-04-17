#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define FIFTH (2.0 * PI / 5.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution * 2.0 - vec2(1.0);
	position.x /= resolution.y / resolution.x;
		
	float vlat = atan(0.5);
	
	
	
	
	if (abs(position.x) <= 1.0) {
		float ry = sqrt(1.0 - position.y * position.y);
		float lon = mod(acos(position.x / ry) + time * 0.5, 2. * PI);
		
		float rx = sqrt(1.0 - position.x * position.x);
		
		if (abs(position.y / rx) < 1.0) {
			float lat = asin(position.y / rx);
			gl_FragColor = vec4(mod(vec2(lat, lon), 0.2) * 5., 5., 1.0);
		}
	}
	else {
		gl_FragColor = vec4(vec3(-3.0 + 2.*length(position))*vec3(0.1, 0.3, 0.5), 1.);
	}
}