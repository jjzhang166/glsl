#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float col = sin(gl_FragCoord.x*gl_FragCoord.y + time*8.0);
	float shade = sin(sqrt(pow(gl_FragCoord.x - resolution.x/2.0,2.0)+pow(gl_FragCoord.y - resolution.y/2.0,2.0)) + time*16.0);
//	gl_FragColor = vec4(col*sin(time), col - cos(time/3.0), col/mod(time, 1.0), 1.0);
	gl_FragColor = vec4(col*sin(time)*0.5 - shade, shade*0.5 - col, tan(shade - col), 1.0);
}