#ifdef GL_ES
precision mediump float;
#endif

uniform float time;


vec3 color = vec3(0.0);
 
void main() {

	color.x = sin(time * 5.0);
	gl_FragColor = vec4(color.rgb, 1.0);
}