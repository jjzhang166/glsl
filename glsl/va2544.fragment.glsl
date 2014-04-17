#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 c = sqrt(gl_FragCoord.xy / resolution);
	
	gl_FragColor = vec4(abs(sin(time*35.0))*c.x, 0, abs(sin(time*25.0))*c.y, 1);

}