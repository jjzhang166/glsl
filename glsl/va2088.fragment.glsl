#ifdef GL_ES
precision mediump float;
#endif

// I'm trippin' balls, man

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	if (sin(time*3.14159*60.0)>0.0)discard;
	gl_FragColor = vec4(mod(time * 1000.0 * sin(gl_FragCoord.x * 3874.0) * sin(gl_FragCoord.y * 1029.0), 1.0), 
			    mod(time * 2000.0 * sin(gl_FragCoord.x * 7425.0) * sin(gl_FragCoord.y * 4954.0), 1.0), 
			    mod(time * 3000.0 * sin(gl_FragCoord.x * 2674.0) * sin(gl_FragCoord.y * 5575.0), 1.0), 
			    1.0);
}