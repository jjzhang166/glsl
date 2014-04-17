#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float color = 0.0;

	color = sin(time + gl_FragCoord.x / 8.3);
	color += sin(time + gl_FragCoord.y / 8.3);
	color += sin(time + (gl_FragCoord.y + gl_FragCoord.x) / 16.0);
	color += sin(sqrt(gl_FragCoord.y * gl_FragCoord.y + gl_FragCoord.x*gl_FragCoord.x) / 8.3);
	color /= 4.0;
	
	
	gl_FragColor = vec4(color, 0.0, 0.0, 1.0 );
}