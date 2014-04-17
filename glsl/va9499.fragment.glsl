#ifdef GL_ES
	precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(){
	vec2 position = (vec2(gl_FragCoord.xy / resolution.xy) + mouse) * 8.25;
	
	float delta = time * 0.8;
	vec3 frag_color = vec3(0.9647, 0.5450, 0.1215) * sin(delta);
	
	gl_FragColor = vec4(frag_color * sin(position.x * 2.0 + delta) * sin(position.y * 1.0 + delta), 0.0);
}