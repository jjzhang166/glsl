// by @jimhejl

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 light_position = vec3(mouse.xy, 20);
vec4 light_color = vec4(1, 0, 0, 1);
float light_radius = 10.0;
float light_falloff = 2.0;

int light_mode = 0;
//0 - Point Light
//1 - Directional Light
//2 - Spot Light



void main(){

	vec3 p = vec3(gl_FragCoord.xy / resolution.xy, 20);

	float d = distance(p, gl_FragCoord.xyz);
	float attenuation = pow(max(0.0, 1.0 - (d / light_radius)), light_falloff + 1.0);

	gl_FragColor = vec4(light_color.rgb, attenuation);
	
}