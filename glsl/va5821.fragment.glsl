#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash(const float n)
{
	return fract(sin(n)*43758.5453);
}

float noise(const vec3 x)
{
	vec3 p=floor(x);
	vec3 f=fract(x);

    	f=f*f*(3.0-2.0*f);

    	float n=p.x+p.y*57.0+p.z*43.0;

    	float r1=mix(mix(hash(n+0.0),hash(n+1.0),f.x),mix(hash(n+57.0),hash(n+57.0+1.0),f.x),f.y);
    	float r2=mix(mix(hash(n+43.0),hash(n+43.0+1.0),f.x),mix(hash(n+43.0+57.0),hash(n+43.0+57.0+1.0),f.x),f.y);

	return mix(r1,r2,f.z);
}

float cloud(const vec3 p)
{
	float f=0.0;

    	f += 0.50000*noise(p*1.0*10.0);
 //   	f += 0.25000*noise(p*2.0*10.0);
    	f += 0.12500*noise(p*4.0*10.0);
 //   	f += 0.06250*noise(p*8.0*10.0);
	f*=f;

	return f;
}

vec3 land(const vec3 p)
{
	float f=0.0;

    	f+=0.50000*noise(p*1.0*10.0);
    	f+=0.25000*noise(p*2.0*10.0);
    	f+=0.12500*noise(p*4.0*10.0);
    	f+=0.06250*noise(p*8.0*10.0);
	f*=f;

	
	return vec3(0.3*f,0.4*f,0.2*f)*(abs(p.z)+6.5);
}

void main(void)
{
	vec2 pos=vec2(gl_FragCoord.x+(resolution.y-resolution.x)/2.0,gl_FragCoord.y)/resolution.yy*2.0-1.0;

	vec3 d1=vec3(pos.x*0.5*pos.y*0.5,100.0,pos.y*0.5);
	vec3 d2=vec3((time*0.01)+pos.x*0.5*pos.y*0.5,time*0.001,pos.y*0.5);

	vec3 colour=(pos.y<0.0)?
		land(d1):
		cloud(d2)+mix(vec3(1.0,0.7,0.0),vec3(0.2,0.2,0.5),(pos.y*0.68)+0.3);

	gl_FragColor=vec4(colour,1.0);
}
