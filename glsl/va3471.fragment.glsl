//@ME
// rotwang: @mod* variation
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

float curve( float a, float b)
{
	return smoothstep( 0.45, 0.55, sqrt( pow(cos(a), 8.0) + pow(sin(b),8.0)) );
}

float thing(vec2 pos) 
{
	float offset = 0.;
	float row = floor((pos.y)/2.0);
	float g = sin(time)*0.5+0.5;
	if (mod(row, 1.0) < g)
		offset = g;
	
	float a = curve(pos.x, pos.x +offset);
	float b = curve(pos.y, pos.y +offset);
	float c = max(a, b) * (sqrt(a*b));
	
	float d = curve(pos.x, pos.x -offset);
	float e = curve(pos.y, pos.y -offset);
	float f = ( d - e ) * (sqrt(d*e));
	return smoothstep(2.+sin(time), -c, f);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 10.;
	world.x *= resolution.x / resolution.y;
	float dist = 1.0-thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
