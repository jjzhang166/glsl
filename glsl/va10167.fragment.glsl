#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = atan(1.)*4.;

float cdist(vec2 v1,vec2 v2)
{
	return max(abs(v1.x-v2.x),abs(v1.y-v2.y));
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy-(resolution/2.) );

	vec3 c = vec3(0);
	vec3 box = vec3(0);
	
	for(float i = 0.;i < 6.;i++)
	{
		float a = time+i*(pi*2./6.);
		
		box = vec3(cos(a)*256.,0,((sin(a)*.5+.5)+0.75));
		
		c += (cdist(p,box.xy) < 64.*(1./box.z)) ? vec3(1) : vec3(0);
	}

	gl_FragColor = vec4( c , 1.0 );

}