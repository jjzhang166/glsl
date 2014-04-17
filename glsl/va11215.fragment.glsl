// ペンかけた\n
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float speed=1.0;
float smallr=0.25;
float penr=0.8;
float delay=0.97;

vec2 o2n(vec2 v)
{
	float c=2.5;
	return vec2(
		(v.x-resolution.x*0.5)*c/resolution.y,
		(v.y-resolution.y*0.5)*c/resolution.y
		);
}

float d2i(float d)
{
	return pow(0.01/d, 2.0);
}

float circle(vec2 me,vec2 o,float r)
{
	float d=length(me-o)-r;
	return d2i(d);
}

float big(vec2 me)
{
	return circle(me,vec2(0.0,0.0),1.0);
}

float small(vec2 me)
{
	float t=time*speed;
	float r=1.0-smallr;
	return circle(me,vec2(r*cos(t),r*sin(t)),smallr);
}


float pen(vec2 me)
{
	float t=time*speed;
	float r=1.0-smallr;

        vec2 p=vec2(r*cos(t),r*sin(t));
	float t2=t-t/smallr;
	float r2=smallr*penr;

	vec2 p2=vec2(r2*cos(t2),r2*sin(t2));
	
	return d2i(length(p+p2-me));
}

void main( void )
{
	vec2 npos = o2n(gl_FragCoord.xy);
	float i=0.0;
//	i+=big(npos);
//	i+=small(npos);
	i+=pen(npos);

	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos)*delay;	
	gl_FragColor=zenkai+vec4(i,i,i,1.0);	
}
