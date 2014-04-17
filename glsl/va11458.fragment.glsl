#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	
	float tmpY = sin(position.x / 50.0 + time) * 400.0;

	float r = 1.0 - abs(position.y - tmpY) / (abs(cos(time)) * 100.0);
	
	gl_FragColor = vec4(r, 0.0, 0.0, 1.0);

}