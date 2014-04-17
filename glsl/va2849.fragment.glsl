//just messing round with some raymarching
//rotate code copied from other
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 RotateX( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( vPos.x, c * vPos.y + s * vPos.z, -s * vPos.y + c * vPos.z);
	
	return vResult;
}
 
vec3 RotateY( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( c * vPos.x + s * vPos.z, vPos.y, -s * vPos.x + c * vPos.z);
	
	return vResult;
}
     
vec3 RotateZ( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( c * vPos.x + s * vPos.y, -s * vPos.x + c * vPos.y, vPos.z);
	
	return vResult;
}


float xrand(vec2 co){
   // co-=mod(co,0.2);
    float x=fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	
	return x;
}


float rand(vec2 co){
    co-=mod(co,0.2);
    float x=fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	x=pow(x,5.0)*2.0;
	if(abs(co.x)-2.0>0.0)
	{
		x+=sin(co.x);
		x+=sin(co.y);
	}
	
	return x;
}

float prand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float prand2(vec2 co){
    float x=sin(dot(co.xy ,vec2(12.9898,78.233)));
	return x*x*x;
}


vec3 c01(float x)
{
	x*=2.0;
	return(vec3(x*x*1.2,x*x,x)+vec3(0.1,0.2,0.4))*0.5;
}

vec3 c02(float x)
{
	return mix(vec3(14.0,12.0,6.0),vec3(0.1,0.2,0.4),x);
}

vec3 sh(vec3 p)
{
	float c=0.0;
	for (float n=0.0; n<100.0; n++)
	{
		vec3 q=p;
		q.xz+=(prand2(vec2(n))-vec2(0.2,-0.7));
		q.y+=(prand2(vec2(n))+0.1);
		if(rand(q.xz)<q.y)
		{
			c++;
		}
	};	
	c=c*0.01;
	float mm=mod(p.y+0.15-rand(vec2(p.x,p.z)),1.0/16.0);mm-=mod(mm,1.0/32.0);
	//float m2=mod(p.x,1.0/16.0);m2-=mod(m2,1.0/32.0);
	c=c*0.8;
	return c01(c);
}

vec3 rm(vec3 s,vec3 d,vec3 od)
{
	
	d=mix(d,od,length(d)*19.0-35.0);
	d=-d;
	d=normalize(d);
	float sun = pow(length(d-normalize(vec3(-0.2,0.4,0.5)))*0.5,0.1);
	
	vec3 c = vec3(0.,0.,0.);
	float i,li,dd;
	dd=0.0;
	
	for(float i=0.0; i<250.0; i+=1.0)
	{
		if(s.y>4.00&&d.y>0.0)
		{
			li=250.0;
			break;
		}
		dd+=0.024;
		s+=d*pow(2.0,dd)*0.005;
		
		if (rand(s.xz)>s.y)
		{
			s-=d*pow(2.0,dd)*0.01;;
			for(float j=0.0; j<10.0; j++)
			{
				
				s+=d*pow(2.0,dd)*0.001;
				if(rand(s.xz)>s.y)
				{
					c=vec3((10.0-j)/10.0);
					break;
				}
			}
			
			c=sh(s);
			break;
		}
	}
	
	
	if (sun>1.0) sun = 1.0;
	return mix(c,c02(sun),pow(max(li,i)/250.0,1.5));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )-0.5;
	float aspect=resolution.x/resolution.y;

	vec3 col;
	vec3 sp=vec3(0.+sin(time*0.1)*sin(time*0.043)*2.0,2.0+sin(time*0.2)*0.2+0.2,time);
	
	vec3 rdir=vec3(position,0.0);
	rdir.x*=aspect;
	rdir.z=2.00;
	rdir=RotateX(rdir,sin(time*0.123)*0.6+0.4);
	rdir=RotateY(rdir,time*0.1);
	rdir=RotateZ(rdir,sin(time*0.023125)*0.4);
	
	vec3 od=vec3(0.0,0.0,2.0);
	od=RotateX(od,sin(time*0.123)*0.6+0.4);
	od=RotateY(od,time*0.1);
	od=RotateZ(od,sin(time*0.023125)*0.4);
	
	col=rm(vec3(0.,0.,0.)+sp,rdir,od);
	
	col*= (1.0-pow(position.x*position.x+position.y*position.y,0.5));
	float w = col.x+col.y+col.z;w*=0.33;
	col = mix(col,vec3(w,w,w),w);
	gl_FragColor = vec4( col+prand(position+time)/233.0, 1.0 );

}