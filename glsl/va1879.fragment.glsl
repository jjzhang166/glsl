//simple mandelbrot http://www.cs.uaf.edu/2009/fall/cs441/lecture/11_24_GPU.html

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

vec2 c=vec2(4.0,3.0)*((gl_FragCoord.xy/resolution)-0.5)+vec2(0.0,0.0); /* constant c, varies onscreen*/
vec2 z=c;

for (int i=0;i<15;i++) {
	if (z.x*z.x+z.y*z.y>=10.0) break;
	/* z = z^2 + c;  (where z and c are complex numbers) */
	z=vec2(
		z.x*z.x-z.y*z.y,
		2.0*z.x*z.y
	)+c;
}
gl_FragColor=fract(vec4(z.x,z.y,-z.x,1.0));}