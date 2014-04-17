#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float To16Bit(float a)
{
	return a - mod(a,0.0625);
	
}

// triangle check nicked from http://www.blackpawn.com/texts/pointinpoly/

bool SameSide(vec3 p1, vec3 p2, vec3 a, vec3 b)
{
    vec3 cp1 = cross(b-a, p1-a) ;
    vec3 cp2 = cross(b-a, p2-a) ;
    if (dot(cp1, cp2) >= 0.0)
	{
		return true;
	}
    return false;
}

bool PointInTriangle(vec3 p, vec3 a,vec3 b, vec3 c)
{
    if (SameSide(p,a, b,c) && SameSide(p,b, a,c) && SameSide(p,c, a,b) )
	{
		return true;
	}
    return false;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.yy );//+ mouse / 4.0;
	vec3 colour = vec3( 1.2 - To16Bit(position.y/0.7), 1.2 - To16Bit(position.y/0.7), 0.8);
	
	
	if (position.y < 0.6)
	{
		colour.r = 1.0;
		colour.g = 1.0;
	}
	
	
	vec3 top = vec3(0.5, 0.8, 0.0);
	vec3 bottom [4];
	
	for (int i=0; i<4; i++)
	{
		bottom[i].x = 0.5 + 0.4*sin( time + float(i) * 3.14159/2.0);
		bottom[i].y = 0.3 + 0.05*cos( time + float(i) * 3.14159/2.0);
		bottom[i].z = 0.0;
	}
	
	for (int i=0; i<4; i++)
	{
		vec3 p1, p2;
		
		p1 = bottom[i];
		if (i==3)
		{
			p2 = bottom[0];	
		}
		else
		{
			p2 = bottom[i+1];
		}
		
		if (cross(top-p1, top-p2).z<0.0)
		{
			if (PointInTriangle(vec3(position,0.0), top, p1, p2))
			{
				colour = vec3(p1.x*1.2,p1.x*1.2,0.0);
			}
		}
	}

	gl_FragColor = vec4( colour, 1.0 );

}