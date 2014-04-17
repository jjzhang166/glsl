// TV Noise, https://twitter.com/#!/baldand/status/159884748855058433
// Originally designed to fit in a tweet with just a bit of boilerplate. 
// (Don't set higher res than 2 or it spoils the effect!)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 u = ( gl_FragCoord.xy / 2.0 +2.0);
	float w,x,y,z=0.0;vec3 c;
	u+=vec2(20.,11.+fract(time));y=fract(u.x*u.x*u.y*u.y*50.);c=vec3(y);
	gl_FragColor = vec4(c,1.);
}