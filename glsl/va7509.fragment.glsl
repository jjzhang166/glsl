#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 color = vec3(.0);
	vec2 center = resolution / 2.;
	float dist = 256.;
	float r = dist * 1.05;
	
	vec2 c0 = center + vec2(-dist, -dist);
	vec2 c1 = center + vec2(-dist, dist);
	vec2 c2 = center + vec2(dist, dist);
	vec2 c3 = center + vec2(dist, -dist);
	
	float d2c = length(center - gl_FragCoord.xy);
	float d0 = length(c0 - gl_FragCoord.xy);
	float d1 = length(c1 - gl_FragCoord.xy);
	float d2 = length(c2 - gl_FragCoord.xy);
	float d3 = length(c3 - gl_FragCoord.xy);
	
	if (d0 > r && d1 > r && d2 > r && d3 > r && d2c < dist) color = vec3(1.);
	
	

	gl_FragColor = vec4(color, 1.0);

}