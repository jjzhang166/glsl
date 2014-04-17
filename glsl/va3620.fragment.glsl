//@ME 
//Stones
//TODO: colors, cover with moss, ...

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    	return res;
}

float fbm( vec2 p )
{
    	float f = 0.0;
    	f += 0.50000*noise( p ); p = m*p*2.02;
    	f += 0.25000*noise( p ); p = m*p*2.03;
    	f += 0.12500*noise( p ); p = m*p*2.01;
    	f += 0.06250*noise( p ); p = m*p*2.04;
    	f += 0.03125*noise( p );
    	return f/0.984375;
}

vec3 thing(vec2 pos) 
{
	float row = floor((pos.y)/80.);
	if (mod(row, 2.0) < 1.0)
		pos.x += 40.;
	
	vec2 p = pos*0.0125;
	float n1 = fbm(p * 4.0);
	p.x = fract(p.x+.5)-0.5;
	p.y = fract(p.y+.5)-0.5;
	p = abs(p);
   	float a = atan(p.y, p.x);
	float b = atan(p.x, p.y);
	float n2 = fbm(p * 1.5) * (a * b);
	float n3 = n1 * 0.15 / n2 * .75;
	float s = min(p.x,p.y) - n3;
	float f = mix(s, 1.-n1, 0.5);
	return vec3(p, f);
}
vec3 n1,n2,n3,n4;
vec2 size = vec2(-0.2,0.0);
void main(void) 
{
	vec2 p = gl_FragCoord.xy;

	vec3 color = vec3(0.0);
	vec2 off = vec2(p.x,p.y-1.0);
	n1 = thing(off);
	off = vec2(p.x-1.0,p.y);
	
	n2 = thing(off);
	
	off = vec2(p.x+1.0,p.y);
	
	n3 = thing(off);
	
	off = vec2(p.x,p.y+1.0);
	
	n4 = thing(off);
	
	vec3 va = normalize(vec3(size.xy,n2.z-n3.z));
	vec3 vb = normalize(vec3(size.yx,n1.z-n4.z));
	
	vec3 p2m = vec3(-((p/resolution)-mouse)*resolution,64.0);	
	
	vec3 normal = vec3(cross(va,vb));
	
	vec3 temp = vec3(dot(normal.xyz, p2m)/96.0);
	float a = 0.4;
	color = a * normal + (1.0 - a) * temp;
	
	color *= vec3(clamp(1.0-distance(mouse*resolution,p)/resolution.x*2.0,0.0,1.0));
	
	gl_FragColor = vec4( color, 1.0 );
}