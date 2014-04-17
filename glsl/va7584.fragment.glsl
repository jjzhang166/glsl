#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main() {
	float radius = 10.;
	/*vec2 LightResolution = floor(vec2((resolution + vec2(3 * radius)) / vec2(2 * radius + 1)));
	bool LightStatus[3000];
	for(int i = 0; i < 3000; i++) { Lightstatus[i] = 1; } */
		
	vec2 LightIndex = floor((gl_FragCoord.xy + vec2(radius)) / vec2(2.0 * radius + 1.0 ));
	vec2 LightPos = LightIndex * vec2(2.0 * radius + 1.0 );
	
	
	vec2 LightIndexMouse = floor(((mouse * resolution) + vec2(radius)) / vec2(2.0 * radius + 1.0));
	
	float intensity = 1.0 - (distance(gl_FragCoord.xy, LightPos) / float(radius));
	
	float intensity2 = clamp(7.0 - distance(LightIndex, LightIndexMouse), 0., 7.)/7.;
	
	vec3 color = vec3(abs(sin(time)), abs(sin(time*2.)), abs(sin(mod(time/20.,4.0))));
	vec3 FinalColor = color * vec3(intensity) * vec3(intensity2);
	gl_FragColor = vec4(FinalColor, 1.0);
}