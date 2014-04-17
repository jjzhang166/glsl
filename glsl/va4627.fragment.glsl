#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec4 outc = vec4(0.0);
	
	//if (abs(gl_FragCoord.y - 550.0) < sin(time+(gl_FragCoord.x/resolution.x)*10.0)*100.0 ) {
	if (abs(gl_FragCoord.y - (sin((gl_FragCoord.x/resolution.x)*100.0+time*10.0)*100.0 + (resolution.y/2.0))) < cos(gl_FragCoord.x/resolution.x*200.0)*5.0 ) {
		outc = vec4(sin(time+(gl_FragCoord.x/resolution.x)*100.0)+1.0,tan(time+(gl_FragCoord.x/resolution.x)*100.0)+1.0,cos(time+(gl_FragCoord.x/resolution.x)*100.0)+1.0,1.0);
	}
	gl_FragColor = outc;

}