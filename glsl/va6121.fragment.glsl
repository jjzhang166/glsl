#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define E_PI 3.1415926535897932384626433832795028841971693993751058209749445923078164062

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	for(float i = 0.0; i < E_PI*2.; i+=E_PI*2./900.)
	{
		float tt = time+(time*i);
		float color = 0.0;
		float lcontr= 0.0;
		vec2 _lpos = vec2(0.5+atan(tt*2.0)*0.2*cos(tt), 0.5+atan(tt*2.0)*0.2*sin(tt));	
		lcontr = 1.0 / distance(_lpos,position)*0.1*(abs(sin(tt)));
		//gl_FragColor += lcontr * vec4(0.01*(sin((time))),0.1*(sin((tt))),0.1*(cos((tt))),.10);
		gl_FragColor += lcontr * vec4(0.01*abs(sin(tt)), 0.01*abs(sin(tt)), 0.01, .5);
	}
}