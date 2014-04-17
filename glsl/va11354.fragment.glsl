#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define OPTIONS 2
#define TIME 10
#define N 100
#define PI 3.14159265

float g (vec2 z)
{
	if (z.x < z.y)
	{
		return floor((1.0 - z.y) / (1.0 - z.x) * float(N));
	}
	else
	{
		return floor(z.y / z.x * float(N));
	}
}

float f (vec2 z)
{
	return g(z)+g(vec2(1.0-z.x,z.y))+1.0;
}

float dotmul (vec2 x, vec2 y)
{
	return x.x*y.x + x.y*y.y;	
}

void main( void ) {
	float maxn = float(2*N);
	float maxn2 = maxn*maxn;
	float z = 0.5 + 0.5*cos(time*2.0*PI/float(TIME));
	vec2 position2;
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	
	if (OPTIONS == 1)
	{
		position2 = vec2( gl_FragCoord.x / resolution.x , mouse.y ); 
	}
	else if (OPTIONS == 2)
	{
		position2 = vec2(position.x,z);
	}
	float color = f(position)*f(position2);
	vec2 colorvec = vec2(cos(color*2.0*PI/maxn2), sin(color*2.0*PI/maxn2));

	gl_FragColor = vec4( vec3( dotmul(vec2(1.0,0.0),colorvec), 
				   dotmul(vec2(-0.5,sqrt(3.0)*0.5), colorvec),
				   dotmul(vec2(-0.5,-sqrt(3.0)*0.5), colorvec)), 1.0 );
	
}