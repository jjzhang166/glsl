#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float x = gl_FragCoord.x/resolution.x; 
	float y = gl_FragCoord.y/resolution.y; 
	float t = sin(time * 2.);
	float value = sin(x*50.0)*cos(y*50.0) + (length(y / t - 0.1) * 0.75);
	gl_FragColor = vec4(value * t, value / t, value * t, 1.0);

}