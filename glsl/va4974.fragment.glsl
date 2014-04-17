// changed to use circle instead square by @rotwang

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14
#define FIFTH (2.0 * PI / 5.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution * 2.0 - vec2(1.0);	// position of the sphere
	
	position.x /= resolution.y / resolution.x;
		
	float vlat = sin(1.05);		// vlat atan()
	
	float len = length(position);
	vec3 color = len*vec3(0.5, 0.4, .5);
	
	if (len <= 2.0) {
		float ry = sqrt(3.5 - position.y * position.y);
		float lon = mod(acos(position.x / ry) + time * 0.5, 0.5 * PI);
		
		float rx = sqrt(3.5 - position.x * position.x);
		
		if (abs(position.y / ry) < 1.0) {
			float lat = asin(position.y / rx);
			color = vec3(mod(vec2(lat, lon), 0.1) * 7.5, 2.5);
		}
	}
	
	gl_FragColor = vec4(color, 1.);
	
}