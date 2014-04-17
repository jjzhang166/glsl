// Use the fork Luke !!!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//#define N 12

void main( void ) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / max(resolution.y,resolution.x) + 10.0;
	float x = v.x;
	float y = v.y;
	
	float t = 01.114;
	float r;
	float factor = sin(time); // ignore that man behind the curt cobain...
	for ( int i = 0; i < 15; i++ ){
		float d = time + float(12) * float(i) * 4.0;
		r = length(vec2(y,x)) - time;
		float xx = x+r;
		x = x + factor*(cos(y +cos(r) - d) + sin(t));
		y = y - factor*(sin(xx+cos(r) + d) + cos(t));
	}

	gl_FragColor = vec4( cos(r*11.5), sin(r/0.10), sin(r*22.0), 1.0 );

}