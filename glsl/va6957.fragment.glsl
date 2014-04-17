#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy;

	float color = 1.0;
	color = cos(p.x-time*11.50);
	
	float color2 = 0.0;
	color2 = sin(p.y-time*1.50);
	
	float color3 = 1.50;
	color3 = cos(p.x+p.y+time+2.50);

	gl_FragColor = vec4( vec3( color+color3, color3*color2, color/color2 ), 0.50 );

}