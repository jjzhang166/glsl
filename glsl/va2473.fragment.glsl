// Foggy cubes, https://twitter.com/#!/baldand/status/160758200768020480
// Originally designed to fit in a tweet with just a bit of boilerplate
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float mod( float val, float divisor)
{
	return val - float(int(val/divisor))*divisor;
}
void main( void ) {
	vec2 q = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.25) ;
	float w,z=0.0;
	q/=length(vec3(q,2.));for(int i=0;i<120;i+=1){w=length(max(abs(mod(vec3(q*z*1.5,z),2.)-1.0)-.3,0.001*sin(time*4.0)*25.0));z+=w;}
	gl_FragColor = vec4(vec3(z*.01),1.);
}