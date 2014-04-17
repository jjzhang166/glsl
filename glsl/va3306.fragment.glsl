// trial & error learning of bezier projection :)
// just ignore it

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 pointA = vec2(0.0, 0.0);
vec2 pointB = vec2(1.0, 1.0);
vec2 pointN = vec2(0.0, 1.0);

/*
PARAM c[1] = { { 1, 0 } };
TEMP R0;
MUL R0.x, fragment.texcoord[0], fragment.texcoord[0];
SLT R0.x, R0, fragment.texcoord[0].y;
ABS R0.x, R0;
CMP R0.x, -R0, c[0].y, c[0];
CMP result.color, -R0.x, c[0].y, fragment.color.primary;
END
*/

float colorshade(vec2 position)
{

	float u, v;
	//                   factor B.x                factor A.x
	u = -position.x + ((1.-pointB.x) * position.y) ;// * 1. + 1.*pointA.x -(1. - 1.*pointB.x) - 0.*pointN.x;
	v = position.y;// * (pointB.y - pointA.y);
	float shade = (u * u) - v;
	if(shade < 0.01 && shade > -.01)
		return 1.;
	else
		return 0.;
	
	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	if(position.x < .2 && position.y < .1)
	gl_FragColor = vec4(1.0,0.0,0.0,0.0);
	else
	gl_FragColor = vec4( position.x * position.x * 1./0.5 - position.y,  colorshade(position), .0, .0);

}