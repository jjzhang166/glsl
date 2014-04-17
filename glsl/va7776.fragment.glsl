#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 p){
	return fract(sin(p.x)*58946.+cos(p.y)*40888.);
}

void main( void ) {
	vec2 position =  gl_FragCoord.xy / resolution.xy ;
	float color = rand(position*time)-length(mouse)/1.3;	
	gl_FragColor = vec4(vec3(tan(color),sin(color),0.),1);
}