// Leaf spin, https://twitter.com/#!/baldand/status/159886208288296960
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
	y=atan(p.y,p.x)/6.28+time*.1;z=length(p*2.);y=abs(fract(y*4.)*2.-1.)-z;c=vec3(0.,y,0.);
	gl_FragColor = vec4(c,1.);
}