#ifdef GL_ES
precision mediump float;
#endif

//rotating 4D fractal

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265
#define RES 100
#define N 48


vec2 f (vec2 z, vec2 c)
{
	return vec2(z.x*z.x-z.y*z.y, 2.0*z.x*z.y)+c;	
}

float opa(float x)
{
	return 0.5*(1.0-cos(x*PI));
}

vec4 perm( vec4 x )
{
	return vec4(x.y,x.z,x.x,x.w);
}

vec4 pointColor( vec4 x )
{
	x = perm(x);
	int iter = 0;
	vec2 y = vec2(x.x,x.y);
	vec2 c = vec2(x.z,x.w);
	for (int i=0; i<N; ++i)
	{
		y = f(y,c);
		++iter;
		if (sqrt(y.x*y.x+y.y*y.y)>4.0)
		{
			break;
		}
	}
	float fiter = float(iter)/float(N);
	return vec4(1.0-fiter,0.0,fiter/2.0,opa(fiter));
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float A = 0.1682346794;
	float B = 0.4786687313;
	float tim = time*A;
	float timb = time*B;
	vec4 pos = vec4(4.0*cos(tim)-sin(tim)*(-2.0+4.0*position.x), 4.0*sin(tim)+cos(tim)*(-2.0+4.0*position.x), 2.0*cos(timb)-2.0+4.0*position.y,-2.0+4.0*mouse.x);
	vec4 camDir = -1.0*vec4(4.0*cos(tim), 4.0*sin(tim), 2.0*cos(timb), 0.0);
	float depth = 10.0/sqrt(camDir.x*camDir.x+camDir.y*camDir.y+camDir.z*camDir.z+camDir.w*camDir.w);
	
	vec3 color = vec3(0.0, 0.0, 0.0);
	for (int i=0; i<RES; ++i)
	{
		vec4 temp = pointColor(pos + camDir * depth * (1.0 - float(i)/float(RES)));
		vec3 newCol = vec3(temp.x,temp.y,temp.z);
		float opa = temp.w;
		color = color * (1.0 - opa) + newCol * opa;
	}
	
	gl_FragColor = vec4( color, 1.0 );

}