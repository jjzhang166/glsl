#ifdef GL_ES
precision mediump float;
#endif

#define portalT vec2(500.0, 500.0)
#define portalB vec2(520.0, 564.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define m (mouse.xy * resolution.xy)

float AngleBetween(vec2 a, vec2 b)
{
	return asin((b.y-a.y)/distance(a,b));
}

bool Inside(vec2 point)
{
	float A = AngleBetween(portalT, m);
	float B = AngleBetween(point, m);
	float C = AngleBetween(portalB, m);
	
	if(A > B && B > C)
	{
		return true;
	}
	
	return false;
}

void main()
{
	if(Inside(gl_FragCoord.xy))
	{
		gl_FragColor = vec4(0.39, 0.58, 0.93, 1.0);
	}
	
	if(distance(gl_FragCoord.xy, portalT) < 5.0 || distance(gl_FragCoord.xy, portalB) < 5.0)
	{
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}
}