#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 computeColor( vec2 p ) {
	p -= 0.1*vec2(cos(2.0*time+sin(time)), sin(3.0*time+cos(time)));
	vec3 col = vec3(1.0);
	float r = length(p); // distance from center
	float a = atan(p.x, p.y); // polar coords
	float s = 0.1 + 0.7*sin(10.0*time+a*5.0);
	float d = 0.2 + 0.5*s*cos(time);
	float f = (r<d)?1.0:0.0; // fill inside of the curve
	float h = r/d;
	float z = 0.5*(1.0+cos(time*5.0));
	float y = 0.5*(1.0+sin(time*3.0));
	return mix(vec3(0.2), vec3(h*y, h*z, 1.0), f);
}

void main( void ) {
	vec2 p = gl_FragCoord.xy/resolution.xy - 0.5;
	vec3 star1 = computeColor(p);
	vec3 star = computeColor(p+0.1*sin(time));
	gl_FragColor = vec4(star,1.0);
}