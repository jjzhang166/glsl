#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	
	float bw = 21.0;
	float bh = 7.0;
	float lw = 2.0;
	float x = gl_FragCoord.x;
	float y = gl_FragCoord.y;
	float bx = mod(gl_FragCoord.y, bw*2.0) < bw ? x + bw/2.0 : x;
	
	
	vec3 color = vec3(0.25);
	if ( mod(y+lw, bh) < lw || mod(bx, bw) < lw ) {
		color = vec3(0.5);	
	}
	
	gl_FragColor = vec4(color, 1.0);

}