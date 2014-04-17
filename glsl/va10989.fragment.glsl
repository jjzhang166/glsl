#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void){
	gl_FragColor = vec4(vec3(sin(time * 20.0) * sin(gl_FragCoord.x / 10.0) + sin(mouse.x), cos(time * 20.0) * cos(gl_FragCoord.y / 10.0) + sin(mouse.y), 0), 1);
}