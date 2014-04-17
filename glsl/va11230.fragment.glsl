#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 res;

float height(vec2 p)
{
	p.x -= res.x/4.;

	float c = 0.0;
	
	for(float i = 0.;i < 8.;i++)
	{
		for(float j = 0.;j < 8.;j++)
		{
			float s = clamp(1.-distance(p,vec2(i+sin(time+j),j+cos(time-i))/8.)*4.,0.,1.);
			c = abs(c-s);
		}
	}
	
	return c;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 res = vec2(1.,1.);
	
	float c = height(p);
	float u = height(p+vec2(0,2)/resolution);
	float r = height(p+vec2(2,0)/resolution);
	//c = 1.-pow(c,0.2);
	vec2 size = vec2(-0.02,0.0);
	vec3 n = cross(normalize(vec3(size.yx,c-u)),normalize(vec3(size.xy,c-r)));
	//n.z = abs(n.z);
	

	gl_FragColor = vec4( vec3( n*.5+.5 ), 1.0 );

}