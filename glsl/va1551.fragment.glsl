#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = (gl_FragCoord.xy / resolution.xy);
	
	vec2 pos = vec2(uv.x - 0.5, uv.y - 0.5);
	
	float intensity = 1.0 - ((1.0 / abs(sin(time * 1.0))) * sqrt(pos.x * pos.x + pos.y * pos.y)) / 0.25;
	
	
	
	vec3 color = vec3(intensity);

	gl_FragColor = vec4(color, 1.0);

}