#ifdef GL_ES
precision mediump float;
#endif
// dashxdr was here 20120228

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rainbow(float x)
{
	x=fract(0.16666 * abs(x));
	if(x>.5) x = 1.0-x;
	if(x<.16666) return 0.0;
	if(x<.33333) return 6.0 * x-1.0;
	return 1.0;
}

void main( void ) {

	vec2 position = ( 2.0*gl_FragCoord.xy - resolution) / resolution.x;

	vec3 color = vec3(0.0);

	float r = length(position);
	float a = atan(position.y, position.x);

	float b = a*1./sin(time * .001)*24000.0/3.14159;
	color = vec3(rainbow(b+3.0), rainbow(b+1.0), rainbow(b+0.0));

	//float t = .5*(1.0 + cos(a + 40.0 * r * (1.0 + sin(a*20.0)*.1) - time*3.0) * (5.0 / (r+5.0)));

	gl_FragColor.rgba = vec4(color, 1.0);

}