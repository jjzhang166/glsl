#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 12

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;
	
	float x = v.x;
	float y = v.y;
	
	float t = time * 0.4;
	float r;
	float factor = 2. * cos(time*.1); // ignore that man behind the curtain...
	for ( int i = 0; i < N; i++ ){
		float d = 3.14159265 / float(N) * float(i) * 5.0;
		r = length(vec2(x,y)) + 0.01;
		float xx = x;
		x = x + factor*(cos(y +cos(r) + d) + cos(t));
		y = y - factor*(sin(xx+cos(r) + d) + sin(t));
	}

	gl_FragColor = vec4( cos(r*0.5), cos(r*1.0), cos(r*2.0), 1.0 );

}