#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 color(vec2 pos, float d){
	vec2 uv = abs(fract(pos*40.)-.5)*d*40.;
	return vec3(1.-min(uv.x, uv.y));
}

vec2 transform(vec2 pos){
	float x = pow(length(pos), 0.15);
	float y = atan(pos.x, pos.y) / (3.1415926*2.0);
	return vec2(x, y);
}

void main( void ) {
	vec2 pos = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y;
	float d = length(pos);
	gl_FragColor = vec4(color(transform(pos)+mouse*.5, d)*vec3(0.0, 1.0,0.0), 1.)*d;
}