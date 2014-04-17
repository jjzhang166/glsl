

#ifdef GL_ES
precision mediump float;
#endif

//http://glsl.heroku.com/e

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float checkers(vec2 p, vec2 pos) {
	float size = 20.0 + sin(pos.x+time*7.0)*2.0 ;
	return floor(sin(p.x*size) * sin(p.y*size)*100000.0);	
}

void main( void ) {

	vec2 pos= ( gl_FragCoord.xy / resolution.xy );
	vec2 move = vec2(cos(time), sin(time*2.0)) * 0.2;
	float val = checkers(pos+move, pos);
	vec3 col = hsv(0.5, 1.0, val);
	
	gl_FragColor = vec4(col, 1.0);

}

