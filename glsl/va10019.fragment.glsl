#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
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
 
void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2. - vec2(1.);
	position.y *= resolution.y / resolution.x;
	
	float slow_time = time / 36000.;
	
	
	gl_FragColor = vec4(
		  stars(slow_time, position)
		);
}