#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define Z .5
#define F 3.

vec3 pt(float x, float y)
{
	vec3 o = vec3(0., 0., 0.);
	o.z = sin(cos((x + (sin(time / 20.) * -2.)) * 2.) * 20. * sin(time) + y * 20.);
	o.x = o.z * .1;
	o.y = o.z * .7;
	return o;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = 0.;
	float g = 0.;
	float b = 0.;
	for(int i = 0; i < 4; i++)
	{
		vec3 p = pt((position.x - float(i)) * (length(position-mouse) * F * Z + (1.-F) * Z), (position.y + sin(time / 10.)) * (length(position-mouse) * Z) * F + (1.-F) * Z);
		r += p.x;
		g += p.y;
		b += p.z;
	}
	
	gl_FragColor = vec4( r, g, b, 1.0 );

}