#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 light1(vec2 pos){
	return vec3(0.,0.,pow(.1,sqrt(distance(pos,vec2(-sin(time),cos(time))))));
}

vec3 light2(vec2 pos){
	return vec3(pow(1./3.,2./sqrt(distance(pos,vec2(-sin(time))))),0.,0.);
}

vec3 light3(vec2 pos){
	return vec3(0.,pow(0.01,sqrt(distance(vec2(cos(time),sin(time)),pos))),0.);
}

vec3 light4(vec2 pos){
	return vec3(pow(.1,sqrt(distance(pos,vec2(sin(time),-cos(time))))),0.,0.);
}

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec3 color = vec3(0.0);
	color += light1(pos);
	color += light2(pos);
	color += light3(pos);
	color += light4(pos);
	gl_FragColor = vec4(color,1);
}