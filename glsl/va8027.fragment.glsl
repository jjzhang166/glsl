#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand();
vec2 seed = vec2(0.123, 0.613);
float rand() 
{
	float f = (cos(dot(seed ,vec2(21.3898,78.233))) * 43758.5453);
	seed.x = fract(f);
	return fract(f);
}

float randvec(vec2 ab) 
{
	float f = (cos(dot(ab.xy ,vec2(21.3898,78.233))) * 43758.5453);
	return fract(f);
}

void main( void )
{
	vec2 pos = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.yy;
	vec3 color;// = vec3(0.7,0.28,0.6);
	
	float dist = length(pos);
	float intens = dist/0.03/ ( abs(sin(time) + sin(time*2.0)/2.0 + sin(time*2.0)/3.0 + sin(time)/5.0) + 0.25);
	float b_intens = intens*2.0;
	vec3 circle = vec3(intens*0.4, intens*0.65, intens*0.16);
	vec3 b_circle = vec3(b_intens*0.4, b_intens*0.65, b_intens*0.16);
	circle = clamp(circle,0.0,1.0);
	b_circle = clamp(b_circle,0.0,1.0);
	color = 1.0-circle;
	//color -= 1.0-b_circle;
	
	float dist2 = length(pos - vec2(0.6,0.0));
	float intens2 = dist2/0.1/abs(sin(0.05*time));
	vec3 circle2 = vec3(intens2*0.34, intens2*0.65, intens2*0.6);
	circle2 = clamp(circle2,0.0,1.0);
	color += 1.0-circle2;
	
	float dist3 = length(pos - vec2(-0.6,0.0));
	float intens3 = dist3/0.1/abs(sin(0.5*time));
	vec3 circle3 = vec3(intens3*0.94, intens3*0.45, intens3*0.9);
	circle3 = clamp(circle3,0.0,1.0);
	color += 1.0-circle3;
	
	gl_FragColor = vec4(color, 1.0);

}