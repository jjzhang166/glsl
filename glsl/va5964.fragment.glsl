#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main() {
	int radius = 16;
	//vec2 LightResolution = floor(vec2((resolution + vec2(3 * radius)) / vec2(2 * radius + 1)));

		
	vec2 LightIndex = floor((gl_FragCoord.xy + vec2(radius)) / vec2(2 * radius + 1 ));
	vec2 LightPos = LightIndex * vec2(2 * radius + 1 );
	
	
	vec2 LightIndexMouse = floor(((mouse * resolution) + vec2(radius)) / vec2(2 * radius + 1));
	
	float intensity = 1.0 - (distance(gl_FragCoord.xy, LightPos) / float(radius));
	float intensity2 = -1.0;//(4.0 - distance(LightIndex, LightIndexMouse)) / 4.0;
	
	
	vec3 color = vec3(0.2, 0.5, 0.0);
	vec3 FinalColor = color * vec3(intensity) * vec3(intensity2);
	gl_FragColor = vec4(FinalColor, 1.0);
}