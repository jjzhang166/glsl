#ifdef GL_ES
precision mediump float;
#endif

#define RAD (3.14159/180.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    //p = m*p*2.02; f += 0.03125*abs(noise( p ));	
    return f;
}
void intersect_first_plane(vec3 dir,vec3 pos,vec3 planenormal,float planeoffset,out float near,out float far,out vec3 normal)
{
	float negheight=planeoffset-dot(pos,planenormal);
	float slope=dot(dir,planenormal);
	float t=negheight/slope;

	if(slope<0.0)
	{
		near=t;
		far=1000.0;
		normal=planenormal;
	}
	else
	{
		near=-1000.0;
		far=t;
	}
}
	
void intersect_plane(vec3 dir,vec3 pos,vec3 planenormal,float planeoffset,inout float near,inout float far,inout vec3 normal)
{
	float negheight=planeoffset-dot(pos,planenormal);
	float slope=dot(dir,planenormal);
	float t=negheight/slope;

	if(slope<0.0)
	{
		if(t>near)
		{
			near=t;
			normal=planenormal;
		}
	}
	else
	{
		if(t<far)
		{
			far=t;
		}
	}
}

float find_intersection(vec3 dir,vec3 pos,out vec3 normal)
{
	float near,far;

	intersect_first_plane(dir,pos,normalize(vec3(0.0,1.0,0.0)),0.5,near,far,normal);
	if(far<0.0 || near>far)
		return -1.0;
	
	const float faces = 8.0;
	
	for(float i = 0.0;i < faces;i++)
	{
		float a =((360.0/faces)*i)*RAD;	
		
		intersect_plane(dir,pos,normalize(vec3(cos(a), 1.0, sin(a))),1.0,near,far,normal);
		if(far<0.0 || near>far) return -1.0;
		intersect_plane(dir,pos,normalize(vec3(cos(a), -1.0, sin(a))),1.0,near,far,normal);
		if(far<0.0 || near>far) return -1.0;
	}

	return near;
}

vec3 environment(vec3 dir)
{
	return  mix(vec3(0.5,0.75,1.0)*(fbm(dir*16.0)*0.5)+0.5,vec3(1.0),dir.y*1.5);
}

mat3 transpose(mat3 m)
{
		return mat3(m[0][0],m[1][0],m[2][0],
			    m[0][1],m[1][1],m[2][1],
			    m[0][2],m[1][2],m[2][2]);
}

void main()
{
	vec2 position=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	vec3 pos=vec3(0.0,0.0,-8.0);
	vec3 dir=normalize(vec3(position,1.0));

	float a=0.45;
	float b=time;
	mat3 rot=mat3( cos(b),0.0,-sin(b),
		          0.0,1.0,    0.0,
		       sin(b),0.0, cos(b));
	rot*=mat3(1.0,    0.0,   0.0,
		      0.0, cos(a),sin(a),
		      0.0,-sin(a),cos(a));

	mat3 inv=transpose(rot);
	vec3 localdir=rot*dir;
	vec3 localpos=rot*pos*0.33;

	vec3 localnormal;
	float t=find_intersection(localdir,localpos,localnormal);
	if(t>=0.0)
	{
		vec3 normal=inv*localnormal;
		vec3 reflected=dir*dot(dir,normal)-normal;
		gl_FragColor=vec4(environment(reflected),1.0);
	}
	else
	{
		gl_FragColor=vec4(environment(dir),1.0);
	}
}
