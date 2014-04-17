#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	gl_FragColor = vec4(0.5, sin(time) * 0.2, 0.3, 1.0 );

	if(mod(gl_FragCoord.x, 20.0) < 10.0 && (mod(gl_FragCoord.y, 20.0) < 10.0)) {
		gl_FragColor.b -= 10.0;
		gl_FragColor.g *= (0.5 + cos(time + gl_FragCoord.y));
	}
	
	if(!(mod(gl_FragCoord.x, 20.0) < 10.0) && !(mod(gl_FragCoord.y, 20.0) < 10.0)) {
		gl_FragColor.b -= 10.0;
		gl_FragColor.r += cos((time + gl_FragCoord.x) / 2.0);
	}
}
