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

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	p.x *= resolution.x / resolution.y;
	
	float shade = Krysler_618(p);
	vec3 clr = vec3(shade*0.2, shade*0.66,shade*1.0);
	
	gl_FragColor = vec4( clr, 1.0 );
}