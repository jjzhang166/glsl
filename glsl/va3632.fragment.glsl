#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 col = vec3(0.5, 0.5, 0.5);
	
	col *= sin(gl_FragCoord.y/10.0)*(cos(mouse.y));
	col /= cos(gl_FragCoord.y/12.0);
	
	col *= sin(gl_FragCoord.x/10.0)*cos(mouse.y);
	col /= cos(gl_FragCoord.y/17.0);
	
	gl_FragColor = vec4( col, 1.0 );

}