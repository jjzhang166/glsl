#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co) {
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
 
float stars(float slow_time, vec2 position) {
	
	float brightness = 0.;
	
	for (int i = 0; i < 100; i++) {
		
		float rand_dist = .01 + 1.2 * rand(vec2(i));
		float rand_pos = 7.*rand(vec2(i+1));
		
		vec2 l_pos = rand_dist * vec2(sin(slow_time + rand_pos), cos(slow_time + rand_pos));
		
		vec2 dist = abs(l_pos - position);
		
		float intensity = 1. - (pow(dist.x, .17) + pow(dist.y, .1));
		intensity = clamp(intensity, 0., 1.);
		
		brightness = brightness + pow(4. * intensity, 2.);
	}
	return pow(brightness, 2.);
}

#define strech_factor 4.
float shooting_star_x(float slow_time) {
	
	return fract(slow_time) * strech_factor - strech_factor / 2.;
}

float shooting_star_y(float slow_time) {
	
	return sin(slow_time) / 2.;
}

vec2 shooting_star_position(float slow_time) {
	
	return vec2(shooting_star_x(slow_time), shooting_star_y(slow_time));
}

float shooting_star(float slow_time, vec2 position, float speed, float show_every_n) {
	
	// speed up
	slow_time *= speed;
	
	// get size by speed
	float size = .02 / abs(speed);
	
	// show only every n-th pass of the shooting star
	if (true || mod(slow_time, show_every_n) < 1.) {
		
		float speed_sign = sign(speed);
		vec2 ss_pos = shooting_star_position(slow_time);
		float intensity = 0.;
		
		// head
		if (speed_sign * position.x > ss_pos.x * speed_sign) {
			
			intensity = size / distance(position, ss_pos);
		}
		
		// tail
		else {
			float prev_y = sin(slow_time - (ss_pos.x - position.x) / strech_factor) / 2.;
			
			intensity = size / abs(position.y - prev_y);
		}
		
		return (.05 * abs(speed) - distance(position, ss_pos)) * intensity;
		
	} else
	
		return 0.;
}

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution ) * 2. - vec2(1.);
	position.y *= resolution.y / resolution.x;
	
	float slow_time = time / 16.;
	
	
	gl_FragColor = vec4(
				stars(slow_time, position) +
				shooting_star(slow_time, position, 4., 3.) + 
				shooting_star(slow_time, position, 14., 2.) +
				shooting_star(slow_time, position, -6., 3.) + 
				shooting_star(slow_time, position, -2., 2.)
			);
}