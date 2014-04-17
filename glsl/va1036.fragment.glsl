#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 red = vec3(1.0, 0.2, 0.2);
const vec3 green = vec3(0.0, 1.0, 0.0);
const vec3 bluish = vec3(0.0, 0.5, 1.0);
const vec3 yellow = vec3(1.0, 1.0, 0.0);
const vec3 axesMajor = vec3(0.0, 0.55, 0.0);
const vec3 axesMinor = vec3(0.0, 0.35, 0.0);

void drawFormula( float left, float right, float res, vec3 color, inout vec3 fragment )
{	
	if ( abs( left - right ) < res*40.0 ) {
		fragment = color;	
	}
}

void main( void )
{
	vec3 fragment = vec3(0.0);
	
	// Settings/preparations
	float minX = -16.0;
	float minY = -10.0;
	float maxX = 16.0;
	float maxY = 10.0;
	float x = (gl_FragCoord.x/resolution.x + 0.5 * (mouse.x - 0.5))*(maxX-minX)+minX;
	float y = (gl_FragCoord.y/resolution.y + 0.5 * (mouse.y - 0.5))*(maxY-minY)+minY;
	float res = 2.0/(resolution.x+resolution.y);
	
	// Axes
	drawFormula( min(mod(abs(x), 1.0), mod(abs(y), 1.0)), 0.0, res*0.8, axesMinor, fragment);
	drawFormula( min(abs(x),abs(y)), 0.0, res*0.9, axesMajor, fragment);
	
	// y = x^3
	drawFormula( y, x*x*x, res*(1.0+abs(y))/2.0, red, fragment );
	// y = log( x )
	drawFormula( y, log(x), res*(5.0+abs(y*0.1))/8.0, bluish, fragment );
	// x^2 + y^2 = 9
	drawFormula( x*x + y*y, 9.0, res*(2.0+abs(y)), yellow, fragment );
	
	gl_FragColor = vec4( fragment, 1.0 );
}