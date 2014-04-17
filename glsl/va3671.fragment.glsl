// by rotwang, some tests for Krysler
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;

float Krysler_616(vec2 p)
{
	float t = (atan(p.y, p.x) + 3.14159) / 3.14159;
	float r = t/0.5;
	float ra = length(p) * t/r;
	
	ra = r - ra;
	
	float a = smoothstep(0.5,1.0,fract(ra));
	float b = smoothstep(0.5,1.0,1.0-fract(ra));
	float shade = a+b;
	
	return shade;
}

float Krysler_617(vec2 p)
{
	float t = (atan(p.x, 1.0-p.x) + 3.14159) / 3.14159;
	float r = t*16.0;
	float ra = length(p*r) * t/r*5.0;
	
	ra = r - ra;
	
	float a = smoothstep(0.33,1.0,fract(ra));
	float b = smoothstep(0.95,1.0,1.0-fract(ra));
	float shade = a+b;
	
	return shade;
}

float Krysler_618(vec2 p)
{
	float t = (atan(p.x, p.y) * PI*2.0) / PI;
	float ra = length(p*t);
	
	float a = smoothstep(0.8,1.0,fract(ra));
	float b = smoothstep(0.8,1.0,1.0-fract(ra));
	float shade = a+b;
	
	return shade;
}

float Krysler_619(vec2 p, float d)
{
	float t = (atan(p.x, p.y) * PI*2.0) / PI;
	float ra = length(p*d);
	
	float a = smoothstep(0.9,1.0,fract(ra));
	float b = smoothstep(0.1,1.0,1.0-fract(ra));
	float shade = a+b;
	
	return shade;
}

vec3 Krysler_619_clr(vec2 p)
{
	float a = Krysler_619(p, 3.0);
	float b = Krysler_619(p, 2.0);
	vec3 clr_a = vec3(a*0.2, a*0.66,a*1.0);
	vec3 clr_b = vec3(b*0.2, b*0.66,b*0.66);
	
	//vec3 clr = mix( clr_a,clr_b, 0.75);
	vec3 clr =  clr_a+clr_b;
	return clr;
}




void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	p.x *= resolution.x / resolution.y;
	vec3 clr = Krysler_619_clr( p);
	gl_FragColor = vec4( clr, 1.0 );
}