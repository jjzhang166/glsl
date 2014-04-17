#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float c = cos(time * 4.0), s = sin(time * 4.0);
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;
	vec2 prot = vec2(position.x * c + position.y * s, position.x * s - position.y * c);
	vec2 pat = sin(prot*50.0) + cos(prot*100.0);
	if (position.x * position.x + position.y * position.y < 0.1) {
		gl_FragColor = vec4(pat , c, 1.0 );
	} else {
		gl_FragColor = vec4(0, 0, 0, 0);
	}

}