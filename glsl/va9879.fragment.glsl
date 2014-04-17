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
		return brightness;
}
 
float shooting_star(float slow_time, vec2 position, float speed, float size, float show_every_n) {
	
	// speed up
	slow_time *= speed;
	
	// show only every n-th pass of the shooting star
	if (mod(slow_time, show_every_n) < 5.) {
		
		float x = fract(slow_time) * 2. - 1.;
		
		vec2 ss_pos = vec2(x, sin(slow_time) / 2.);
		
		float center_intensity = size / length(position - ss_pos);
		
		// tail
		float tail_intensity = 0.;
		for (float tailStep = 0.; tailStep < 5.; tailStep += 1.) {
		  slow_time -= .001 * speed;
		
		  x = fract(slow_time) * 2. - 1.;
		
		  ss_pos = vec2(x, sin(slow_time) / 2.);
		
		  tail_intensity += size / length(position - ss_pos) / (tailStep + 1.);
		}
		
		return .5 * (center_intensity + tail_intensity);
		
	} else
	
		return 0.;
}

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2. - vec2(1.);
	position.y *= resolution.y / resolution.x;
	
	float slow_time = time / 8.;
	
	
	gl_FragColor = vec4(
		  stars(slow_time, position) +
		  shooting_star(slow_time, position, 4., .002, 3.) + 
		  shooting_star(slow_time, position, 14., .004, 2.) +
		  shooting_star(slow_time, position, -6., .0015, 3.) + 
		  shooting_star(slow_time, position, -12., .005, 2.)
		);
}