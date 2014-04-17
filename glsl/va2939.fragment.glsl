// Leaf spin, https://twitter.com/#!/baldand/status/159886208288296960
// Originally designed to fit in a tweet with just a bit of boilerplate

// @mod* rotwang
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	p -= vec2(0.5);
	p *= vec2(0.5);
	
	float t = time / 12.0;
	float st = sin(t);
	float ct = cos(t);
	
	float w,x,y,z=0.0;
	vec2 u;
	vec3 c;
	y=atan(p.y*ct,p.x*st)/6.28+t;
	z=length(p*2.);
	y=abs(fract(y*4.)*2.-1.)-z*st*0.5;
	y *= 0.66;
	c=vec3(0.0,y+(ct*0.3),y-(st*0.3));
	gl_FragColor = vec4(c,1.);
}