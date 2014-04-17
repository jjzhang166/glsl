#ifdef GL_ES
precision highp float;
#endif

uniform float time;

void main(void) {
	float red = 1.0 + sin(time) * 0.15;
	float green = 1.0 + sin(time) * 0.15;
	float blue = 1.0;
	
	vec3 rgb = vec3(red, green, blue);
	vec4 color = vec4(rgb, 1.0);
	gl_FragColor = color;
}