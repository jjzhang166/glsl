#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float color = 1.0;
	float lcontr= 1.0;
	
	vec2 _lpos = vec2(sin(time*200.0)*0.02,0.01*sin(time*310.1415)) + mouse;
	
	lcontr = 1.0 / distance(_lpos,position)*0.1;
	

	gl_FragColor = lcontr * vec4(0.2 + 0.1*sin(time),0.4+0.3*cos(3.3*time),0.4+0.17*sin(3.21*time),1.0);

}