#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

vec4 color(vec2 pos){
	float x =  pow(sin(pos.x * 3.1415 * 6.0), 2.0);
	float div = 3.14 * 1.0;
	float offset = 0.0;
	if((mod(pos.x * 3.0, div) - div * 0.5) > 0.0){
		offset = 10.0;
	}
	
	return vec4(mix(0.5, pow(sin(pos.y * 3.14 * 2.0), 6.0 + offset), pow(1.0 / pos.y, 1.2)));
}

vec2 transform(vec2 pos){
	float theta = atan(pos.y, pos.x);
	float r = length(pos);
	float dir = 1.0;
	if(mod(r, 4.0) > 2.0){
		dir = -1.0;
	}
	return vec2(theta + time * 0.01 / r * 0.1 * 1.0 * dir, 1.0 / r);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy * 2.0 - resolution) / resolution.y;

	gl_FragColor = color(transform(pos));

}