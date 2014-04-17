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
	for ( int i = 0; i < N; i++ ){
		float d = 3.14159265 / float(N) * float(i) * 5.0;
		r = length(vec2(x,y)) + 0.01;
		float xx = x;
		x = x + cos(1.4*y +cos(r*.5) + d) + cos(t);
		y = y - sin(xx+cos(r) + d) + sin(t);
	}

	gl_FragColor = vec4( cos(r*mouse.x), cos(r*mouse.y), cos(r*mouse.x/mouse.y), 1.0 );

}