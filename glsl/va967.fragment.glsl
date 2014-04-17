#ifdef GL_ES
precision mediump float;
#endif

//Learning simple effects
//XOR effect from http://adrianboeing.blogspot.com/2011/01/xor-demoeffect-in-webgl.html

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy *2.0 - 1.0;
	vec2 offset = vec2(sin(time),cos(time));
	
	float r1 =inversesqrt(dot(sin(time + p),cos(p + time)));
	float r2 = inversesqrt(dot(p+offset,p+offset));
	
	bool b1 = mod(r1,0.1)>0.05;
	bool b2 = mod(r2,0.1)>0.05;
	
	if(b1 && b2)
	    gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
	

}