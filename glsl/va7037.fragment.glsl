#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

float noise(float s)
{
	return fract(cos(s*115.)*1234.);
}
void main( void ) 
{

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) ;
	p=surfacePosition*0.3;
	vec3 c=vec3(0);
	float s1=20.;
	float s2=75.;
	
	for (int a=0;a<40;a++)
	{
		float r=noise(p.x+p.y);
	c.y+=floor(noise(floor((floor((p.x+s2)*s1)+(noise(floor((p.x+20.)*s2))-0.5)*time*0.1+(p.y+20.))*s1))*1.08);
	c.z+=floor(noise(floor((floor((p.y)*s1)+(noise(floor(p.y*s1))-0.5)*time*0.1+p.x)*s2))*1.08);
	c.x+=(c.y+c.z)/64.;
	p+=p*0.1*.5*r*c.x;
	}
	c*=1./26.;
	
	gl_FragColor = vec4( c, 1.0 );

}