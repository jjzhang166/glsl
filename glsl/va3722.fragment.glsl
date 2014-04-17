#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 point = vec2(0, 0);

void main( void ) {
	vec2 pos = vec2(gl_FragCoord.x - (resolution.x/2.0), gl_FragCoord.y - (resolution.y/2.0));
	
	vec2 modifier = vec2(sin(time*3.0)*resolution.x/2.0*cos(time*0.02), cos(time)*resolution.y/2.0*sin(time*3.0));
	point += modifier;
	
	float f = 2.0 / exp2(distance(point, pos)*0.1);	

	vec3 color = vec3(0.5, 0.7, 0.8) * f;
	gl_FragColor = vec4(color, 1.0);
}