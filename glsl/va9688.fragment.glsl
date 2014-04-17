#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float w = resolution.x;
float h = resolution.y;

void main( void ) {
	float move = w / 3.0;
	vec2 pos1 = vec2(w * 0.5 + move * (sin(time)), h * 0.5);
	vec2 pos2 = vec2(w * 0.5 - move * (cos(time)), h * 0.5);
	vec2 pos3 = vec2(w * 0.5, h *  0.5 + move * (tan(time)));
	
	float dist1 = length(gl_FragCoord.xy - pos1);
	float dist2 = length(gl_FragCoord.xy - pos2);
	float dist3 = length(gl_FragCoord.xy - pos3);
	
	// 円のサイズ\n	float size = 50.0;
	
	float color = 0.;
	color += pow(size / dist1, 1.0);
	color += pow(size / dist2, 1.0);
	color += pow(size / dist3, 1.0);
	gl_FragColor = vec4(vec3(0.0, color, color), 1.0);
} 
