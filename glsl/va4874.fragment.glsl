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
		float lon = mod(acos(position.x / ry) + time * 0.3, 2.0 * PI);
		
		float rx = sqrt(1.0 - position.x * position.x);
		
		if (abs(position.y / rx) < 1.0) {
			float lat = asin(position.y / rx);

			int index;
			if (lat > vlat) {
				index = int(lon / FIFTH);
			}
			else if (lat > -vlat) {
				index = 6 + int(lon / FIFTH) * 2;
				float phase = mod(lon, FIFTH);
				if (lat < vlat * (1.0 - 4.0 * phase / FIFTH)) index--;
				else if (lat < vlat * (4.0 * phase / FIFTH - 3.0)) index++;
				if (index == 15) index = 5;
			}
			else {
				index = 15 + int(mod(lon / FIFTH + 0.5, 5.0));
				
			}
			gl_FragColor = vec4(vec3(float(index) / 20.0), 1.0);
		}
	}
	else {
		gl_FragColor = vec4(0.0);
	}
}