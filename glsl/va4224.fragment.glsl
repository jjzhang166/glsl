#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Just learning this, NOOB!

void main( void ) {

	vec2 p = gl_FragCoord.xy;

	float dis = distance(p, mouse);
	
	vec3 color = vec3(1.0,1.0,1.0);
	
	color -= dis/50.;
	
	gl_FragColor = vec4(color, 1.0);

}