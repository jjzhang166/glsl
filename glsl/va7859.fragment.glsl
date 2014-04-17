///Version notes
/// 2	difference between two intersection detection methods
/// 3	Trying some Performance Optimizations
/// 4	recreating the scene graph
/// 5	Added basic shading
/// 10	found artifact - 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	Author:
//   Ashok Gowtham M
//
//
//	References:
//	     -- Raymarching Distance Fields - Inigo Quilezles
//		About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//
//
// notes:
// whenever an artifact occurs, try increasing the iterations
// artifacts can occur in the following cases: (especially when normal calculation is done, but valid otherwise too)
// scene involves negligibly thin plane.
// iterations is low (200 is a good value. but around 30-50 would be sufficent for simple cases.)
//
//
// history: ported basic code written using Shazzam-tool.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/// <summary>Explain the purpose of this variable.</summary>
/// <defaultValue>1</defaultValue>
/// <minValue>1 </minValue>
/// <maxValue>2 </maxValue>
/// <type>float</type>
float p0=1.0;
/// <defaultValue>-0.5,0.5</defaultValue>
/// <minValue>-0.5,-0.5</minValue>
/// <maxValue>0.5,0.5</maxValue>
/// <type>Point</type>
vec2 XLim=vec2(-0.5,0.5);
/// <defaultValue>-0.5,0.5</defaultValue>
/// <minValue>-0.5,-0.5</minValue>
/// <maxValue>0.5,0.5</maxValue>
/// <type>Point</type>
vec2 YLim=vec2(-0.5,0.5);
/// <defaultValue>-0.5,0.5</defaultValue>
/// <minValue>-0.5,-0.5</minValue>
/// <maxValue>0.5,0.5</maxValue>
/// <type>Point</type>
vec2 ZLim=vec2(-0.5,0.5);

/// <defaultValue>0.10</defaultValue>
/// <minValue>0</minValue>
/// <maxValue>1</maxValue>
float p2=0.10;
/// <defaultValue>0.10</defaultValue>
/// <minValue>0</minValue>
/// <maxValue>1</maxValue>
float p3=0.10;
/// <defaultValue>0.10</defaultValue>
/// <minValue>0</minValue>
/// <maxValue>1</maxValue>
float p4=0.10;

/// <defaultValue>0.10</defaultValue>
/// <minValue>0</minValue>
/// <maxValue>1</maxValue>
float p5=0.10;
/// <defaultValue>2.18</defaultValue>
/// <minValue>0</minValue>
/// <maxValue>4</maxValue>
float p6=2.18;


float Sphere( vec3 p, float s )
{
  return length(p)-s;
}

float Box( vec3 p, float b )
{
  return length(max(abs(p)-b,0.0));
}

float Box3( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}

float Union(float p1, float p2)
{
	return min(p1,p2);
}

float Intersection(float p1, float p2)
{
	return max(p1,p2);
}

float Subtract(float p1, float p2)
{
	return max(-p1,p2);
}

vec3 TransX(vec3 p, float dx)
{
	p.x+=dx;
	return p;
}

mat3 TMat;

void init()
{
	float o;
	o=-(mouse.y-.5)*12.0;
	mat3 XRot=mat3(1,	0,	0,
		       0,	cos(o),	-sin(o),
		       0,	sin(o),	cos(o));
	o=-mouse.x*12.0;
	mat3 YRot=mat3(cos(o),	0,	-sin(o),
		       0,	1,	0,
		       sin(o),	0,	cos(o));
	
	TMat=YRot*XRot;
}

float worldDist(vec3 p){
	vec3 q = TMat*p;
	float d=0.0;
	
	float f1,f2,f3,f4,f5;
	
	q.x-=0.5;
			f1=abs(q.y)-0.0001;//plane	//-0.0001 added to give some thickness to plane to avoid artifacts
			f2=length(q)-1.0000000596046;//sphere  ///<-------------[ARTIFACT]  occurs when number graeater than 1.00000005960464
							/// ALSO FPS Increases greatly if the number is greater than that magic value!!!!!!
		f3=max(f1,f2);//Circular Disk
	
		f4=abs(p.y+1.5)-0.01;	//floor
		
	d=min(f3,f4);
	
	return d;
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv-=.5;
	uv.x*=resolution.x/resolution.y;
	
	float hitTolerance=0.01;
	float farPlane=10.0;
	
	vec3 ray,dir,camLoc;
	camLoc = ray = vec3(0,p5,p6);
	dir = normalize(vec3(uv.x*10.0,uv.y*10.0,-6.0));
	
	float dist = 0.0;
	float totDist = 0.0;
	
	//ray intersection
	float collided1=0.0;//detection by checking implicit distance is below threshold
	float collided2=0.0;//detection by checking distance beyond farPlane
	
	init();
	for (int i=0;i<50;i++)
	{
		dist=worldDist(ray);
		totDist+=dist;
		ray+=dir*dist;
		if(totDist>farPlane||dist<hitTolerance)break;
	}
	
	
	
	vec4 col=vec4(0.0,0.0,0.0,0.0);
	
	
//	collided2=(totDist<farPlane)?1.0:0.0;
//	float hasCollided=collided2;
	
//	col.x = fract(ray.x/p2)*hasCollided;
//	col.y = fract(ray.y/p3)*hasCollided;
//	col.z = fract(ray.z/p4)*hasCollided;

	vec3 e=vec3(0.01,0.0,0.0);
	vec3 n;
	
	//simple phong shading
	n=normalize(
		vec3(dist-worldDist(ray-e.xyy),
		     dist-worldDist(ray-e.yxy),
		     dist-worldDist(ray-e.yyx)));
	float b = dot(n,normalize(camLoc-ray));
	col.y=pow(b,411.0)+pow(b,81.0)+abs(b);
	col.y/=3.0;
	col.a=1.0;
	gl_FragColor = col;
}