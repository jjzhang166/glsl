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

float unsin(float t)
{
	return sin(t)*0.5+0.5;
}

float curve( float x)
{
	return smoothstep( 0.5, 0.0,acos(x*PI) ) - cos(x*PI)+0.9;
}

float thing(vec2 pos) 
{
	float a = curve(pos.x + 10.0);
	float b = curve(pos.y);
	float c = distance(b,a/b) * 0.5;
	float d = pow(c,a) * acos(c);
	return (a * b) + (sqrt(a/b)/d)+ c;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 10.0;
	world.x *= resolution.x / resolution.y;
	world = rotate(world, radians(45.));
	float dist = 1./thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
