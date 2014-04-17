// 3D lines, https://twitter.com/#!/baldand/status/159886731758411776
// Originally designed to fit in a tweet with just a bit of boilerplate
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - vec2(.5) + mouse / 4.0;
	float w,x,y,z=0.0;vec2 u;vec3 c;
	z=abs(p.y);x=fract(time+p.x/z*10.);y=smoothstep(0.,.2,x)*smoothstep(.4,.2,x)*z;c=vec3(y);
	gl_FragColor = vec4(c,1.);
}