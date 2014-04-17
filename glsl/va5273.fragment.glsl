#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float colr = 0.0;
	
	float thickness = 0.6;
	float repeatrate = .9;
	
	thickness -=  sin(time + gl_FragCoord.y) + (min((abs(sin(gl_FragCoord.y + time)*2.) + 0.3),0.6) * 0.002) * (2. * (gl_FragCoord.x - 0.5));
	
	if(mod( gl_FragCoord.x, repeatrate) > thickness || mod( gl_FragCoord.y, repeatrate) > thickness)
	{
		colr = 1.0;
	}

	

	gl_FragColor = vec4( colr, 0.0, 0.0, 0.0 );

}