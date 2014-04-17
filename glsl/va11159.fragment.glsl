#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 q;
	q = vec2((1.1+atan(sin(p.x+time)*2.))*(1.2/1.), (1.3+atan(sin(p.y+time)*2.))*(1.2/1.));
		
	vec3 col = vec3(sin(q.x),sin(q.y),sin(q.x*q.y));
	
	gl_FragColor = vec4(col,0);

}