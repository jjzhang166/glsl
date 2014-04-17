#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//circle gradiant, center of screen with a 100 pixel radio.
void main( void ) {	
	float radio = 100.0;
	vec2 center = resolution.xy/2.0;
	vec3 color = vec3(1.0, 1.0, 1.0);
	color.r = clamp(distance(gl_FragCoord.xy, center), 0.0, radio)/radio;
	
	gl_FragColor = vec4(color.rgb, 1.0 );
}