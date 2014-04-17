// made by lumo (my first glsl try!)
// like this here: 
// www.youtube.com/watch?v=smKCfEeW7VI
// trying to create nested hexagons... but EPIC FAIL!
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define M_PI 3.14159265358979323846

void main(void)
{
	float size = 0.05;
	vec2 p =  gl_FragCoord.xy * size + time; 
	float value = 0.0;
	float limit = 0.35;
	float x = 0.0;
	float y = 0.0;

	if (cos(p.x) <= limit) {
		value = clamp((cos(p.x) - cos(p.y)) * 1000., 0.1, 1.0);
	} else {
		value = 1.;
	}
	
	gl_FragColor = vec4(vec3(value), 1.);
}