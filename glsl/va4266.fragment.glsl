// by rotwang, a smooth Poly6Outline nicely shaded
// @mod+ some other test with modulation

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}

vec2 rotate(vec2 p,float angle){
   vec2 q;
   q.x =p.x*cos(angle)-p.y*sin(angle);
   q.y =p.x*sin(angle)+p.y*cos(angle);
   return q;
}

float test( vec2 p, float r, float smooth )
{
    vec2 q1 = rotate(abs(p*p),-0.5);
	vec2 q2 = rotate(abs(q1*p)-q1*0.25,1.8);
	float lfo = sin(time*0.25)*0.5+0.5;
    float d = dot(q1-q2, vec2(0.43, lfo));
	
	
	float shade = max(d*d, q1.y-q2.y)-r*d*0.25;
	 shade = smoothstep(0.0+smooth, 0.0-smooth, shade);
    return shade;
}

float smoothPoly6( vec2 p, float r, float smooth )
{
    vec2 q = abs(p); 
    float d = dot(q, vec2(0.866025, 0.5));
	
	
	float shade = max(d, q.y)-r;
	 shade = smoothstep(0.0+smooth, 0.0-smooth, shade);
    return shade;
}

float smoothPoly6Outline( vec2 p, float r, float smooth, float thick )
{
	float da = smoothPoly6(p, r+thick, smooth);
	float db = smoothPoly6(p, r-thick, smooth);
	db *= length(p*0.5);
	
	float d = da-db;
	d = mix(d,d*p.y,0.5);

    return d;
}


void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;
	
	float d = test(pos, 0.7, 0.01); // smoothPoly6Outline(pos, 0.7, 0.01, 0.03);
	vec3 ca = vec3(0.2,0.6,0.8) *d *1.5;
	vec3 cb = vec3(1.0,0.6,0.2) *d ;
	
	float m = -pos.x+pos.y*1.5;
	vec3 clr = mix(ca,cb, m);
	gl_FragColor = vec4( clr , 1.0 );
}