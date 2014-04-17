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

#define ROTOSPEED 0.5
#define ZOOMSPEED 0.5

void main( void ) {

	vec2 clm = vec2(128);
	vec2 pos = mod( rotate(gl_FragCoord.xy, cos(ROTOSPEED * time)) / cos(ZOOMSPEED * time), clm);
	vec2 mid = clm * 0.5;
    
	if (pos.x > mid.x && pos.y > mid.y){
		gl_FragColor=vec4(0.1, 0.1, 0.1, 0.1);
	}
	if (pos.x < mid.x && pos.y < mid.y){
		gl_FragColor=vec4(0.1, 0.1, 0.1, 0.1);
	}
	
}