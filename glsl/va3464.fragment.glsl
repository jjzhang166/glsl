///@ME
//Wanna see more nice HQ patterns here!

// rotwang @mod* very nice!
// ME @mod* 

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

float curve( float x)
{
	return smoothstep( 1.0, 0.0, cos(x*PI) ) - cos(x*PI);
}

float thing(vec2 pos) 
{
	float offset = 0.;
	float row = floor((pos.y)/2.);
	if (mod(row, 2.0) < 1.0) {
		offset = 1.0;
		pos = rotate(pos, radians(90.*sin(time * 0.5)));
	}
	float a = curve(pos.x) - offset + abs(sin(time));
	float b = curve(pos.y - offset * 1.0) - offset * 0.25;
	float c = max(distance(b,a/b), tan(a) - tan(b));
	float d = pow(a,c) * abs(sin(-time)) + sqrt(c*a) * abs(sin(time));
	float e = inversesqrt(d);
	return (a * b + d) *(sqrt(a/b))+ c / e;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 2. - 1.;
	world *= 5.;
	world.x *= resolution.x / resolution.y;
	world = rotate(world, radians(45.));
	float dist = 1.0/thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
