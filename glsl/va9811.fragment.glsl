#ifdef GL_ES
precision mediump float;
#endif

//Eyebleed pattern-gen
//By Andrew Lake
//@Catlinman_
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy); 
	float color = clamp(fract(sin(sin(position.x * resolution.x) + cos(position.y * resolution.y) + time)),0.0,1.0); 
	gl_FragColor = vec4(color + sin(time), color, color + cos(time), 1.0 );
}