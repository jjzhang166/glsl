/*
 * COLORFUL DOT THINGIE
 * Made by petterroea
 * petterroea.com - me@petterroea.com - @petterroea
 *
 * Fancy colorful dot thingie. This was my inspiration: http://wallpaperswide.com/colorful_circles-wallpapers.html
 * I am supposed to use this on my webpage as a fancy background. Might do that.
 * Plase modify, optimize, whatever :D
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Some stuf from iq. thx.
float hash( float n )
	
{
    return fract(sin(n)*43758.5453);
}

float dist(vec2 p1, vec2 p2)
{
	return sqrt(((p2.x-p1.x)*(p2.x-p1.x))+((p2.y-p1.y)*(p2.y-p1.y)));
}

float checkCircle(vec2 circlePos, vec2 pixelPos, float scale)
{
	float distVar = dist(circlePos, pixelPos)/scale;
	if(distVar < 0.09) { return 0.2; }
	else if(distVar < 0.093) { return 0.1; }
	return 0.0;
}
vec3 colorize(vec2 pos)
{
	float i = pos.x+pos.y;
	return vec3(sin(i*0.7+14.0)+0.3,
		    sin(i*0.7+10.0)+0.5,
		    sin(i))+0.9;
}

void main( void ) {
	vec3 color = vec3(0,0,0);
	
	for(int i=0; i < 100; i++)
	{
		vec2 pos = vec2(
			sin(((time*0.02)+100.0)*hash(float(i)*3.5))*0.9, 
			cos(((time*0.03)+100.0)*hash(float(i)*5.0))*0.9);
		color = color + vec3(checkCircle(pos, ((vec2(gl_FragCoord.x, gl_FragCoord.y)/resolution)*vec2(2))-vec2(1), ((sin(float(i))+1.0)/1.9)+0.7))*colorize(pos);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

	gl_FragColor = vec4(color, 1.0 );
}