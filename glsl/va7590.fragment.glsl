#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define N 3

void main( void ) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;
	
	float t = time*.2;

	float repeat = abs(sin(mouse.y))*10.;
	float factor = abs(sin(mouse.x));
	float r;
	
	for ( int i = 0; i < N; i++ ){
		float d = 3.14159265 / float(N) * 5.0;
		v += vec2(cos(v.y + cos((v.x+t)*factor*d)  - t),sin(v.x + sin((v.y+t)*factor*d)  - t));		
	}
	r = length(v);
	float g = cos(r);
	gl_FragColor = vec4( g*2.*abs(sin(time)), g, g*r*2., 1.0 )*.4+texture2D(backbuffer,gl_FragCoord.xy/resolution)*.6;

}