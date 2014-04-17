#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 realpos = gl_FragCoord.xy / resolution.xy;
	vec2 posdiff = realpos - mouse;

	// Play with these values to change the color effect
	float redval = 7.0;
	float greenval = 5.0;
	float blueval = 10.0;
	float fallof = abs(posdiff.y); //log(1.0-abs(posdiff.y)); //logarithmic? i dont know what im doin here lol
	gl_FragColor = vec4( cos((posdiff.x / posdiff.y) * redval)*fallof, cos((posdiff.x / posdiff.y) * greenval)*fallof, cos((posdiff.x / posdiff.y) * blueval)*fallof, 1.0);
}