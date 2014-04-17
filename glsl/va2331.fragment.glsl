#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.141592

#define pPosition vec2(100, 100)
#define pNormal vec2(1, 0)
#define pWidth 32.0

#define pLeftEnd (pPosition + vec2(-pNormal.y, pNormal.x) * pWidth / 2.0)
#define pRightEnd (pPosition + vec2(pNormal.y, -pNormal.x) * pWidth / 2.0)

uniform vec2 mouse;
uniform vec2 resolution;

float angleTo(vec2 source)
{
	return acos(dot(normalize(source - gl_FragCoord.xy), normalize(mouse * resolution - gl_FragCoord.xy)));
}

bool inside()
{
	float angToLeftEnd = angleTo(pLeftEnd);
	float angToRightEnd = angleTo(pRightEnd);
	float angToMouse = angleTo(mouse);
	
	if(max(angToLeftEnd, angToRightEnd) > angToMouse && min(angToLeftEnd, angToRightEnd) < angToMouse)
	{
		return true;
	}
	
	return false;
}

void drawPoint(vec2 point)
{
	if(distance(gl_FragCoord.xy, point) < 5.0)
	{
		gl_FragColor = vec4(1.0, 0.0, 0.0, 0.0);
	}
}

void main( void )
{
	gl_FragColor = vec4(inside()?1:0);
	
	drawPoint(pLeftEnd);
	drawPoint(pRightEnd);
}