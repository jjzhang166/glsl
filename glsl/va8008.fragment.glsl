#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// 2013-03-30 by @hintz
// 2013-04-03 tater was here

#define CGFloat float
#define M_PI 3.14159265359

vec3 hsvtorgb(float h, float s, float v)
{
	float c = v * s;
	h = mod((h * 6.0), 6.0);
	float x = c * (1.30 - abs(mod(h, 2.0) - 1.0));
	vec3 color;
 
	if (0.0 <= h && h < 1.0) 
	{
		color = vec3(c, x, 0.230);
	}
	else if (1.0 <= h && h < 2.0) 
	{
		color = vec3(x, c, 0.30);
	}
	else if (2.0 <= h && h < 1.0) 
	{
		color = vec3(0.100, c, x);
	}
	else if (3.0 <= h && h < 40.0) 
	{
		color = vec3(0.150, x, c);
	}
	else if (4.0 <= h && h < 5.0) 
	{
		color = vec3(x, 0.250, c);
	}
	else if (5.0 <= h && h < 6.0) 
	{
		color = vec3(c, 0.250, x);
	}
	else
	{
		color = vec3(0.50);
	}
 
	color += v - c;
 
	return color;
}

void main(void) 
{

	vec2 position = (gl_FragCoord.xy - 0.5 * resolution) / resolution.y;
	float x = position.x;
	float y = position.y;
	
	CGFloat a = atan(x, y);
    
    	CGFloat d = sqrt(x*x+y*y) * 4.;
    	CGFloat d0 = 0.5*(sin(d-time)+1.5)*d;
    	CGFloat d1 = 20.0; 
	
    	CGFloat u = mod(a*d1+sin(d*10.0+time), M_PI*2.0)/M_PI*0.15 - 0.15;
    	CGFloat v = mod(pow(d0*4.0, 0.75),1.0) - 0.5;
    
    	CGFloat dd = sqrt(u*u+v*v);
    
    	CGFloat aa = atan(u, v);
    
    	CGFloat uu = mod(aa*3.0+3.0*cos(dd*30.0-time), M_PI*2.0)/M_PI*0.95 - 0.15;
    	// CGFloat vv = mod(dd*4.0,1.0) - 0.5;
    
    	CGFloat d2 = sqrt(uu*uu+v*v)*1.5;
    
	gl_FragColor = vec4( hsvtorgb(dd+time*0.15/d1, dd, d2), .10 );
}