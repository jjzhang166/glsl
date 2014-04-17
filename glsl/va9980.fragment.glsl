#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
} 

#define ROTOFACTOR 4.0
#define ROTOSPEED  0.4

#define ZOOMFACTOR 4.0
#define ZOOMSPEED  0.3

void main( void ) {

	vec2 clm = vec2(128);
	vec2 mid = clm * 0.5;
	vec2 pos = mod( rotate(gl_FragCoord.xy, (ROTOFACTOR * cos(ROTOSPEED * time))) * (ZOOMFACTOR * cos(ZOOMSPEED * time)), clm);
    
	if ((pos.x > mid.x && pos.y > mid.y) || (pos.x < mid.x && pos.y < mid.y)) {
		gl_FragColor=vec4(0.4, 0.16, 0.0, 1.0);
	} else {
		gl_FragColor=vec4(0.1, 0.1, 0.1, 1.0);
	}
	
}