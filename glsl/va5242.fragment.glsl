#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v; }

void main( void ) {

	float PI = 3.14159265358979323846264;

	float alpha = 1.;
	vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	pos.y = cos(pos.y * 2.);

	pos.x = cos(pos.x * 2.);

	float distanceFromCenter = sqrt(pos.x * pos.x + pos.y * pos.y);

	float hue = (atan(pos.x, pos.y) / PI + time * 1.);
	float value = (cos(distanceFromCenter * 100. + 10. * time) + 1.) * 0.5;

	gl_FragColor = vec4(0, value, 0, 1.); //vec4(hsv(hue, 1., value), 1.);
}