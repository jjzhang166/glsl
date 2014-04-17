#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.x / resolution.xy ) + 4.0 * time *0.1;

	float v = abs(sin(position.x * 5.0));
	
	
		
	float v2 = abs(sin(position.y * 50.0));
	
	
	gl_FragColor = vec4(v*vec3(0.0,0.8,1.0)  / v2*vec3(0.0,.4,0.9),1.0);
}