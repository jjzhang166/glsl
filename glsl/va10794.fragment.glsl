#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 offset = -0.5* resolution;
	float intensity = (gl_FragCoord.y + offset.y) / (gl_FragCoord.x + offset.x);
	vec3 color = (vec3(0.8, 0.2,0.7) + abs(sin(time/4.)) - 0.5) * intensity;
	
	intensity = (gl_FragCoord.x + offset.x) / (gl_FragCoord.y + offset.y);
	color += (vec3(0.5, 0.6, 0.7) + abs(sin((time+2.)/3.)) - 0.5) * intensity;
	color /= 2.;
	gl_FragColor = vec4(color, 1.0);
}