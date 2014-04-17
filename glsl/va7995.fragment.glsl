#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float w = resolution.x;
float h = resolution.y;

void main( void ) {
	float move = w / 10.0;
	vec2 pos1 = vec2(500.0 + 50.0*sin(0.20*time), 200.0);
	vec2 pos2 = vec2(500.0 + 200.0, 200.0 + 50.0*sin(10.0*time));
	
	float dist1 = length(gl_FragCoord.xy - pos1);
	float dist2 = length(gl_FragCoord.xy - pos2);
	
	// 円のサイズ\n	float size = 30.0;
	
	float color = 0.;
	color += pow(size / dist1, 2.0);
	color += pow(size / dist2, 2.0);
	gl_FragColor = vec4(vec3(color / 1.0, color / 4.0, color / 1.0), 1.0);
} 
