#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float Tau		= 2.2832;
const float speed	= .07;
const float density	= .04;
const float decay	= .3;
const float shape	= 100.98;		// .16 for dots

float random( vec2 seed ) {
	return fract(sin(seed.x+seed.y*1e3)*1e5);
}

float Cell(vec2 coord) {
	return (.5-length(fract(coord)-.5)*4.)*step(random(floor(coord)),density)*4.;
}

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution - .5;
	
	float a = fract(atan(p.x, p.y) / Tau);
	float d = length(p);
	
	vec2 coord = vec2(pow(d,.08), a)*128.;
	vec2 delta = vec2(-time*speed*128., Tau);
	
	float c = 0.;
	for(int i=0; i<3; i++) {
		coord += delta;
		c = max(c, Cell(coord));
	}
	
	gl_FragColor = vec4( vec3(c*d), 1.0 ) + texture2D(backbuffer, p+.5)*decay;
}