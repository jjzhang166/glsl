#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	float rainbowthing = time;
	float red;
	red = 0.5 + (sin(rainbowthing*2.0 + gl_FragCoord.y/10.0)/2.0 );
	float green;
	green = 0.5 + (sin(rainbowthing*2.0 + 2.0 + gl_FragCoord.y/10.0)/2.0);
	float blue;
	blue = 0.5 + (sin(rainbowthing*2.0+4.0+gl_FragCoord.y/10.0))/2.0;

	vec4 bbuff;
	
	
	gl_FragColor = vec4(red,green,blue,1.0) ;

}