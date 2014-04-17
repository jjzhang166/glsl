// Foggy cubes, https://twitter.com/#!/baldand/status/160758200768020480
// Originally designed to fit in a tweet with just a bit of boilerplate
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 q = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.65) + mouse / 4.0;
	float w,z=0.0;
	q/=length(vec3(q,8.));
	for(int i=0;i<199;i++){
		w=length(max(abs(mod(vec3(q*z,z+time*30.),2.)-1.)-.4,0.));
		z+=w;
	}
	gl_FragColor = vec4(vec3(z*.01),1.);
}