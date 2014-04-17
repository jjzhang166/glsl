#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


vec2 move(vec3 p){
	return vec2(sin(p.x + 3.4) + sin(p.y + 3.4) + sin(p.z + 3.4), sin(p.x+5.5) + sin(p.y+5.5) + sin(p.z+5.5));
}
	
void main( void ) {
	
	vec2 position = gl_FragCoord.xy / resolution.y;
	
	vec2 n;
	float s = 2.;
	for(int i=0; i<5; i++){
		n= move(vec3(position * s, (time + s*2.) * 0.1 * s));
		position += n;
		s *= 1.25;
	}
	
	vec2 l = vec2(0.5, 0.5);
	l = mouse;
	float a = atan(position.y, position.x);
	float i = length(normalize(l)-normalize(position))*.5;
	i = pow(i, 10.);
	a = (a / 3.142) *.5 +1.;
	vec3 c = vec3(
		max(1. - abs(a - 0.333)*3., 0.),
		max(1. - abs(a - 0.667)*3., 0.),
		max(max(1. - abs(a - 0.0)*3., 0.), max(1. - abs(a - 1.0)*3., 0.))
		);
	c = mix(c, vec3(1.), .5);
	gl_FragColor = vec4(c*i, 1.0);
}
