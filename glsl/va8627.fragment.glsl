#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float line(vec2 pt, float off)
{
	float pos = .5 + off * (sin(time)*20.) * (pow(.5 - pt.x, 2.));
	return abs(pos-pt.y)<.005?1.:0.;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.;
	for(int i = 0; i < 50; i++)
	{
		color = max(color, 1. / float(i+1) * 5. * line(position, pow(float(i+1),2.)));
	}

	gl_FragColor = vec4( vec3( color), 1.0 );

}