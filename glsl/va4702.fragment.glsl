// fast noise, psonice

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy/resolution.xy * 100. + time + 100.; 
	
	p *= sin(p.yx);
	p *= sin(p.yx);
	p *= sin(p.yx);
	
	gl_FragColor = vec4(p.x + .5);
}