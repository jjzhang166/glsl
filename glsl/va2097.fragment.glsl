#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	gl_FragColor = vec4(mod(cos(gl_FragCoord.x * 100.0) * sin(gl_FragCoord.y * 155.0), 1.0), 
			    mod(cos(gl_FragCoord.x * 100.0) * sin(gl_FragCoord.y * 255.0), 1.0), 
			    mod(cos(gl_FragCoord.x * 100.0) * sin(gl_FragCoord.y * 2.0), 1.0), 
			    1.0);
}