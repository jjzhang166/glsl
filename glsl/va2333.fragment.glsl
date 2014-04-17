#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.141592

#define pPosition vec2(100, 100)
#define pNormal vec2(1, 0)
#define pWidth 32.0

#define pLeftEnd (pPosition + vec2(-pNormal.y, pNormal.x) * pWidth / 2.0)
#define pRightEnd (pPosition + vec2(pNormal.y, -pNormal.x) * pWidth / 2.0)

#define mouseP (mouse * resolution)
uniform vec2 mouse;
uniform vec2 resolution;

int ccw( vec2 p0, vec2 p1, vec2 p2 )
{
	float dx1, dx2, dy1, dy2;
	
	dx1 = p1.x - p0.x; 
	dy1 = p1.y - p0.y;
	dx2 = p2.x - p0.x; 
	dy2 = p2.y - p0.y;
	
	if (dx1*dy2 > dy1*dx2)
		return +1;
	if (dx1*dy2 < dy1*dx2)
		return -1;
	if ((dx1*dx2 < 0.0) || (dy1*dy2 < 0.0))
		return -1;
	if ((dx1*dx1 + dy1*dy1) < (dx2*dx2 + dy2*dy2))
		return +1;
	return 0;
}

bool sameSide(vec2 lineA, vec2 lineB, vec2 pointA, vec2 pointB)
{
	return ccw(lineA, lineB, pointA) == ccw(lineA, lineB, pointB);
}

bool inside()
{
	if(sameSide(mouseP, pLeftEnd, gl_FragCoord.xy, pRightEnd) && sameSide(mouseP, pRightEnd, gl_FragCoord.xy, pLeftEnd) && !sameSide(pRightEnd, pLeftEnd, gl_FragCoord.xy, mouseP) && !sameSide(pRightEnd, pLeftEnd, mouse, pPosition + pNormal))
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
	gl_FragColor = vec4(inside()?0.5:0.2);
	
	drawPoint(pLeftEnd);
	drawPoint(pRightEnd);
}