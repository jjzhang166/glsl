#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float wave(float a0, float a, float k, float x, float phase){
	return a0 + a * sin( k * x + phase);
}

vec3 wave(vec3 a0, vec3 a, vec3 k, vec3 x, vec3 phase){
	return a0 + a * sin( k * x + phase);
}

vec2 transform(float a, float b, float c, float d, vec2 v){
	return vec2(a*v.x + b*v.y,c*v.x + d*v.y);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy - resolution.xy / 2.0 ) / resolution.yy;
	pos.xy = transform(0.2, 0.3, -0.2, wave(0.5, 0.5, 1.0, time, 0.0), pos.xy);
	vec2 dir = normalize(pos);
	pos.xy += dir * sin(pos.yx + 0.4*time);
	pos.xy *= pos.yx;
	pos.x -= wave(0.0, 0.025, 1.0, pos.y + time, 0.0);
	pos.y -= wave(0.0, 0.015, 1.0, pos.x + time, 0.0);
	pos.xy *= 100.0;
	float r = length(pos);
	float angle = atan(pos.y,pos.x);
	gl_FragColor = vec4( vec3(wave(vec3(0.5),vec3(0.5),vec3(1.0,0.4,1.2),vec3(time+r),vec3(0.0))), 1.0 );

}