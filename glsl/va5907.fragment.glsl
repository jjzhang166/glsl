#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(){
	vec2 p = vec2(100.0, 100.0) / resolution;
	
	vec2 light_pos = p * resolution;
	float radius = 100.0;
	float intensity = 0.25;
	
	/* Euclidean distance between light and pixel */
	float dist = distance(gl_FragCoord.xy, light_pos);
	
	/* Attenuation factor */
	float att =  1.0 / (0.1 + (0.5 * dist) + ((intensity * 0.05) * dist * dist));
	
	/* Glow color */
	vec3 glow_color = vec3( 0.95, 0.35, 0.0);
	/* The final color */
	vec4 final_color = vec4(glow_color, 1.0) * att;
	
	gl_FragColor = final_color;
}