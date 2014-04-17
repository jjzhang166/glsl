//@ME
//Connected

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

float unsin(float t) {
	return sin(t)*0.5+0.5;
}

float curve( float x) {
	return smoothstep( 0.0, 3.0, unsin(x*TWOPI) + cos(x*PI) + sin(x*PI)  ) + unsin(x*TWOPI);
}

float thing(vec2 pos) {
	float offset = 0.;
	float row = floor((pos.y-1.)/2.);
	if (mod(row, 2.0) <= 1.0)
		offset = curve(unsin(pos.x)*sin(time)*0.25);
	float a = 2.5-curve(pos.x + curve(unsin(pos.y)*sin(time)*0.25));
	float b = sin(time * 0.25)*1.75+curve(pos.y - offset);
	float c = (distance(a, b) / sqrt(a/b)) * length(a*b) + 0.25 * 0.5;
	return clamp(c, 0.0, 1.0);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 14.0 - 7.;
	world.x *= resolution.x / resolution.y;
	world = rotate(world, radians(time * 10.0));
	float dist = thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
