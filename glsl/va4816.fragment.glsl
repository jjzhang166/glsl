#ifdef GL_ES
precision mediump float;
#endif

// by Dave Davis

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	// Supernova :p
	vec2 center = resolution.xy / 2.0;
	vec2 position = gl_FragCoord.xy;
	
	float distanceToCenter = abs(length(center - position));
	
	float halo = resolution.x / 1.5 * sin(time);
	
	float intensity = (halo - distanceToCenter) / halo;
	
	gl_FragColor = vec4( 1.0, 0.45, 0.1, 1.0 ) * intensity;

}