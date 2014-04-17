#ifdef GL_ES
precision mediump float;
#endif
// Fixed your typo! :O

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
float dist = distance(gl_FragCoord.xy, vec2(0.5*resolution.x, 0.5*resolution.y)) / resolution.y;
float testVal = dist*35.;
if (dist > 0.4)
{
	float val = testVal / 8. > 1. ? .7 : .3;
	gl_FragColor = vec4(vec3(val), 1.);
}
else
	gl_FragColor = vec4(
	mod(testVal, 4.) > 1.99 ? 1. : 0.,
	mod(testVal, 8.) > 3.99 ? 1. : 0.,
	mod(testVal, 2.) > 0.99 ? 1. : 0.,
	1.0
	);
// end

}