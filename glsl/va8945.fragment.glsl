// by @301z - Shortened by Chaeris. Comment: I don't know what the fuck you tried to do with all those vars but I don't know if it was really "fast", I didn't notice the difference.
// It's still a success, nice idea and work @301z - Chaeris
// based on http://devmaster.net/forums/topic/4648-fast-and-accurate-sinecosine/
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform float time;
void main() {
	vec3 a = vec3 (1.);
	if (distance(vec2(cos(2.*time), sin(2.*time))*0.2, gl_FragCoord.xy/resolution.xy-vec2(0.5)) < 0.1) {
		a = vec3(0.);
	}
	gl_FragColor = vec4(a, 1.);   
}