#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;

float batsur=10.0;
float ir=1.0;


float dist(vec2 a,vec2 b)
{
	float x=a.x-b.x;
	float y=a.y-b.y;
	return pow(x*x+y*y,0.5);
}

float l2d(vec2 a,vec2 b,vec2 p)
{
	float ab=dist(a,b);
	float ap=dist(a,p);
	float bp=dist(b,p);

    if(ab*ab+ap*ap>bp*bp && ab*ab+bp*bp>ap*ap){
		float s=(ab+ap+bp)/2.0;
		float t=pow(s*(s-ab)*(s-ap)*(s-bp),0.5);

		return (t*2.0)/ab;
	}else{
		return (ap<bp ? ap : bp);
	}
}

vec4 d2i(float r,float d)
{
  float intensity=pow(r/d, 2.0);
  vec4 color = vec4(1.0,1.0,1.0,1.0);
  return color*intensity;
}

vec4 l2i(vec2 a,vec2 b,vec2 p)
{
	return(d2i(ir,l2d(a,b,p)));
}

vec4 batsu(vec2 pos,vec2 me)
{
	vec2 mm = vec2(pos.x-10.0,pos.y-10.0);
	vec2 mp = vec2(pos.x-10.0,pos.y+10.0);
	vec2 pm = vec2(pos.x+10.0,pos.y-10.0);
	vec2 pp = vec2(pos.x+10.0,pos.y+10.0);

	return l2i(mm,pp,me)+l2i(mp,pm,me);
}

void main( void )
{
	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos)*0.7;
	gl_FragColor = zenkai+batsu(vec2(mouse.x*resolution.x,mouse.y*resolution.y),gl_FragCoord.xy);
}