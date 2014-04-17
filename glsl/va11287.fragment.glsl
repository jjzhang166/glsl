#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 c = ( gl_FragCoord.xy / resolution.xy ) - vec2(.5,.5); // from http://thndl.com/?5
	vec2 r=abs(c.xy); 
	gl_FragColor = vec4(r,0.,1.);
	
}