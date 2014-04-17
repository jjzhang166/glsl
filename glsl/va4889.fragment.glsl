// Nice function at many scales
// Lots of aliasing and float-precision effects
// Looks best at 1 or 0.5
// @baldand http://thndl.com

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(1.0) + mouse ;
	float scale = pow(2.0,80.0*(fract(-time*0.02))-32.0);
	float raw = tan(1.57079632679-1.0/(scale*position.x*position.y));
	float mapped = abs(fract(raw+time*0.1)*2.0-1.0);
	gl_FragColor = vec4(vec3(mapped),1.0);
}