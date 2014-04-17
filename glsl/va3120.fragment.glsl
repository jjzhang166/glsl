//----------------------------------------------------
// @rotwang 
// Animated and antialiased conical hue gradient
// stolen from sourcecode by Visiomedia Ltd. (c 2012)
//----------------------------------------------------
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

/**
@rotwang:
returns the atan angle
as unipolar normalized value 0..1
*/
float uniatan( vec2 pos)
{
	float a = atan(pos.y, pos.x);
	return (a + PI) / TWOPI;
}

/**
@rotwang:
smoothes between 2 vectors a and b (eg colors)
using a source value and a smooth amount
about the base as center.
*/
vec3 smoothmix(vec3 a, vec3 b, float base, float smooth, float source)
{
	float f = smoothstep(base-smooth, base+smooth, source );
	vec3 vec = mix(a, b, f);
	return vec;
}

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= aspect;
	
	float sint = sin(time);
	float usint = sint*0.5+0.5;
	
	float angle = uniatan(pos);
	float radius=0.5;
	
	float hue = angle;
	float sat = 1.0;
	float lum = 1.0;
	
	vec3 back_clr = vec3(0.3);
	vec3 clr = hsv2rgb(hue, sat, lum);
	
	float fa = dot(pos,pos) + radius;
	float fb = angle + usint;
	float base = max(fa,fb);
	clr = smoothmix(clr, back_clr,  1.0, 0.01, base);
	
	gl_FragColor = vec4(clr,1.0);
	
}