#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 12

void main( void ) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;
	float x = v.x;
	float y = v.y;
	
	float t = pow(5.,length(mouse*1.5));
	float r;
	float factor = cos(.1); // ignore that man behind the curtain...
	for ( int i = 0; i < 4; i++ ){
		float d = 3.14159265 / float(12) * float(i) * 5.0;
		r = length(vec2(x,y)) + 0.01;
		float xx = x;
		x = x + factor*(cos(y +cos(r) + d) + cos(t));
		y = y - factor*(sin(xx+cos(r) + d) + sin(t));
	}
	float g = cos(r);

	gl_FragColor = vec4( g, g*r, g*r, 1.0 );

}