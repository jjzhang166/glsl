#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


vec2 move(vec3 p){
	return vec2(sin(p.x + 3.14) + sin(p.y + 3.14) + cos(p.z + 3.14), sin(p.x+3.14*1.0) + cos(p.y+3.14*1.0) + sin(p.z+3.14*1.0));
}
	
void main( void ) {
	
	vec2 position = gl_FragCoord.xy / resolution.y;
	
	vec2 n;
	float s = 2.;
	for(int i=0; i<3; i++){
		n= move(vec3(position * s, (time*0.05 + s*2.) * 0.1 * s));
		position += n;
		s *= 1.25;
	}
	
	vec2 l = vec2(sin(time*0.5), cos(time*0.5));
	//l = mouse;
	float a = atan(position.y, position.x);
	float i = length(normalize(l)-normalize(position))*.5;
	i = pow(i, 10.);
	//a = (a / 3.142) *0.5 +1.;
	vec3 c = vec3(
		max(2.5 - abs(a - 0.333)*3., 0.5),
		max(2.0 - abs(a - 0.333)*3., 0.5),
		max(max(2. - abs(a - 0.333)*3., 0.5), max(1. - abs(a - 0.333)*3., 0.5))
		);
	c = mix(c, vec3(1.0), .5);
	gl_FragColor = mix(vec4(c*i, 1.0), vec4(1.0,0.0,0.0,10), 0.5)*vec4(0.3,0.8,1.0,1.0);
}
