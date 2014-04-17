#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

// shabby julia set variation

void main( void ) 
{
	vec2 c = surfacePosition*2.5;
	vec2 z = vec2(c);
	float x=0.;
	float ang=time*0.65;
	for (int i = 0; i < 60; i++) 
		{
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		x++;
		ang+=168.1;
		z=vec2(z.x*cos(ang)+z.y*sin(ang),-z.y*cos(ang)+z.x*sin(ang));
		c=cos(z/(z+z+z))/1.65;
		if (dot(z,z)>3.0) break;
		}
	
	x/=60.;
	
	gl_FragColor = vec4(pow(x,.5), pow(x,0.8)*3., pow(x,0.2)*2., 1.0);
	
}