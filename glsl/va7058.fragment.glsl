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
 
	vec2 position = ( 2.0*gl_FragCoord.xy - resolution) / resolution.xx;
 
	vec3 color = vec3(0.0);
 
	float r = length(position)*2.0;
	float a = atan(position.y, -position.x);
 
	float b = a*12.0/3.14159;
	color = vec3(rainbow(b+3.0), rainbow(b+1.0), rainbow(b+0.0));
 color = vec3(0.0, 0.0, 1.0);
	
//	float t = fract((a*r+.30*floor(r*10.0))*5.0);
	float tr = r*5.0;
	float y = fract(tr);
 	float t = fract((a+3.14159)*1.2*floor(tr));
 
	t *= 4.0 * (1.0 - t);
	y *= 4.0 * (1.0 - y);
	gl_FragColor.rgba = vec4(color*t*y, 1.0);
 
}
