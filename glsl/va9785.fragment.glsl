#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 mpos = mouse*resolution;
	
	float color1 = sin(distance(gl_FragCoord.xy,mpos)*+time*10.0);
	float color2 = sin(distance(gl_FragCoord.xy,mpos)+time*10.0);
	float color3 = sin(distance(gl_FragCoord.xy,mpos)+time*10.0);
	
	gl_FragColor = vec4( color1,color2,color3, 1.0 );

}