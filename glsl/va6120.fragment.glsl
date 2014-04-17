#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float color = 0.0;
	float lcontr= 0.0;
	
	vec2 _lpos = vec2(0.2+sin(time*5.0)*0.2,0.5);
	
	lcontr = 1.0 / distance(_lpos,position)*0.1;
	

	gl_FragColor = lcontr * vec4(0.2,0.4,0.4,1.0);

}