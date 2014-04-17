
// by @eddbiddulph

#ifdef GL_ES
precision highp float;
#endif

#define EPS         vec3(0.001, 0.0, 0.0)
#define CELL_SIZE   vec2(0.03, 0.03)
#define STROKE_SIZE vec2(0.03, 0.001)
#define STROKE_RAD  0.01
#define MOT_RAD     0.02

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	gl_FragColor = vec4(1,0,0,1);
}

