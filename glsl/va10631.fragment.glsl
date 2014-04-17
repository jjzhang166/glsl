#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

uniform vec2 resolution;
const float PI = 3.14159265358979323846264;
const float sangle = 10.0;
void main () {
	vec2 center = vec2 (0.5, 0.5);
	float rsangle = sangle * PI/180.0;	
	float res = resolution.x / resolution.y;
	vec2 pos = gl_FragCoord.xy / resolution.xy;

	
	vec2 c = (pos - center);
	float angle=atan(c.y,c.x)-time;
	if ((angle-(floor(angle/rsangle)*rsangle))<0.5*rsangle) {
		gl_FragColor = vec4(1.0,1.0,1.0,1.0);
	} else {
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	}
}