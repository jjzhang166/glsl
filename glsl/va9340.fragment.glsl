#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0 * time * 0.8;

	float v = abs(sin(position.x * 25.0));
	float v2 = abs(sin(position.y * 15.0));
	
	
	gl_FragColor = vec4(v*vec3(0.0,0.8,1.0)  + v2*vec3(0.0,.4,0.5),1.0);
}