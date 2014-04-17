#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = atan(1.)*4.;

struct Gear
{
	vec2 pos;
	float tn,ts,r,ang;
};
	
void gearAngle(Gear p,inout Gear c)
{
	float ratio = p.tn/c.tn;//Gear ratio
	
	float off = pi/c.tn;//One tooth offset
	
	c.ang = -p.ang*ratio+off;
}

vec2 cnorm(vec2 v)
{
	return v/max(abs(v.x),abs(v.y));	
}

float inGear(Gear g,vec2 p)
{
	p-=g.pos;
	float an = atan(p.x,p.y)+g.ang;
	float ra = length(p);
	
	vec2 cs = vec2(cos(an*g.tn),sin(an*g.tn));
	cs = cnorm(cs);
	
	return smoothstep(0.018, 0.02, distance(p, vec2(0., 0.)))*smoothstep(g.r+0.005,g.r,ra-(cs.x*.5+.5)*g.ts);
}

void main( void ) {

	vec2 res = vec2(resolution.x/resolution.y,1.);
	vec2 p = ( gl_FragCoord.xy / resolution.y )-(res/2.);
	
	float a = atan(p.x,p.y)+time;
	float r = length(p);

	vec3 c = vec3(0.0);
	
	Gear drive = Gear(vec2(-0.4,0),16.,0.03,0.2,time);
	
	Gear g1 = Gear(vec2(-0.4,0.34),8.,0.025,0.1,0.);
	gearAngle(drive,g1);
	
	Gear g2 = Gear(vec2(-0.4,-0.34),8.,0.025,0.1,0.);
	gearAngle(drive,g2);
	
	Gear g3 = Gear(vec2(-0.06,0.),8.,0.025,0.1,0.);
	gearAngle(drive,g3);
	
	Gear g4 = Gear(vec2(0.12,0.),4.,0.025,0.04,0.);
	gearAngle(g3,g4);
	
	Gear g5 = Gear(vec2(0.595,0.),32.,0.025,0.4,0.);
	gearAngle(g4,g5);
	
	c = inGear(drive,p)*vec3(0.8,0.,0.);
	c += inGear(g1,p)*vec3(1.,1.,0.);
	c += inGear(g2,p)*vec3(1.,0.,1.);
	c += inGear(g3,p)*vec3(0.,0.,1.);
	c += inGear(g4,p)*vec3(1.,1.,1.);
	c += inGear(g5,p)*vec3(0.,1.,1.);
	
	gl_FragColor = vec4( vec3( c ), 1.0 );

}