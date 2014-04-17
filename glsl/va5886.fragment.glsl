//germangb
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool f (vec2 v) {
	return v.y > sin(v.x * 0.1) * cos(v.y * 0.001 * time * 1.0) * 250.0 * resolution.y / 50.0 + resolution.y / 3.0;	
}

void main( void ) {

	vec3 black = vec3(0.0, 0.0, 0.0);
	vec3 white = vec3(1.0, 1.0, 1.0);
	
	gl_FragColor = vec4( (f(gl_FragCoord.xy)) ? black : white, 1.0 );

}