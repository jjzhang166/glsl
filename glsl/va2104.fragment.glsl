#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	
	if (r < 0.0) {r = 0.0;} else if (r>1.0) {r=1.0;}
	if (g < 0.0) {g = 0.0;} else if (g>1.0) {g=1.0;}
	if (b < 0.0) {b = 0.0;} else if (b>1.0) {b=1.0;}

	r += position.x;
	b += position.y;
	g += sin(time);
	
	gl_FragColor = vec4( r, g, b, 1.0);

}