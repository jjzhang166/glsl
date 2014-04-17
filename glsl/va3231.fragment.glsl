#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
}

struct Sphere {
	vec4 center;
	float radius;
}; //Sphere

Sphere sphere = Sphere(vec4(20.0, 20.0, 20.0, 0.0), 20.0);

