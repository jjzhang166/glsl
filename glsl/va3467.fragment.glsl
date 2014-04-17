//@ME

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

float curve( float x)
{
	return smoothstep( 0.75, 0.0, cos(x*PI) );
}

float thing(vec2 pos) 
{
	float offset = 0.;
	float row = floor((pos.y)/2.0);
	if (mod(row, 2.0) < sin(time)+1.0)
		offset = sin(time) * 2.;
	
	float a = curve(pos.x + offset);
	float b = curve(pos.y);
	float c = (a + b) * (sqrt(a+b));
	
	float d = curve(pos.x + offset);
	float e = curve(pos.y);
	float f = (d - e) * (sqrt(d*e));
	return smoothstep(2.+sin(time), -c, f);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 10.-6.;
	world.x *= resolution.x / resolution.y;
	float dist = 1.0-thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
