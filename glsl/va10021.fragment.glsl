#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	
	vec3 col = vec3(abs(mod(time / 3.0, 2.0) - 1.0), abs(mod(time / 4.0, 2.0) - 1.0), abs(mod(time / 5.0, 2.0) - 10.0));
	
	if (mod(distance(gl_FragCoord.xy - 0.5, floor(mouse.xy * resolution.xy)), 100.0) < 50.0)
		col = (texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb + abs(mod(time, 2.0) - 0.5)) / 2.0;
	//if (floor(distance(resolution.xy / 2.0, gl_FragCoord.xy) + 0.5) == floor(resolution.y / 2.0))
	//	col /= 1.0 - col;
	
	gl_FragColor = vec4(col, 1.0);

}