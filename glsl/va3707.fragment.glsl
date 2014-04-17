// byrotwang, some functions for Krysler

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float speed = time *0.5;
float aspect = resolution.x / resolution.y;
vec2 unipos = ( gl_FragCoord.xy / resolution );
vec2 pos = vec2( (unipos.x*2.0-1.0)*aspect, unipos.y*2.0-1.0);

vec2 rotated(float a, float r) {
	
	return vec2(cos(a*TWOPI)*r, sin(a*TWOPI)*r);
}

vec2 rotate(vec2 p, float a) {
	
	return vec2(cos(p.x*TWOPI*a), sin(p.y*TWOPI*a));
}


float Krysler_190(vec2 p, float blades)
{
	
	
	
	float tt =  sin(speed*0.1);
	p = rotate(p,tt);
	
	float angle = (atan(p.y, p.x)+PI)/TWOPI;
	float r = length(p); 
	
	
	float ra = 0.33; 
	float ma = mod(angle*blades, 0.5);
	float sma = smoothstep(0.25,0.5, ma);
	float f =  sin(sma)*0.5+0.5;
	
	float rb = 0.5 +f*0.33;
	
	float sm = 0.01;
	float a = smoothstep(rb+sm, rb-sm, r);
	float b = smoothstep(ra+sm, ra-sm, r);
	
	float shade = (a-b);

	return shade;
}


vec3 Krysler_190_clr(vec2 p, float blades)
{
	float r = length(p);
	float tt =  sin(speed);
	
	float shade = Krysler_190(p, blades)*r*r;
	shade = r * shade*tt;
	vec3 clr_a = vec3(shade*0.2, shade*0.6, shade*1.0)*4.0;
	clr_a *= clr_a;
	
	vec3 clr_b = vec3(1.0, 0.5, 0.1)* (0.66-r);
	
	return clr_a + clr_b*3.0;
}






void main( void ) {

	vec3 clr = Krysler_190_clr(pos, 6.0);
	gl_FragColor = vec4( clr, 1.0 );
}