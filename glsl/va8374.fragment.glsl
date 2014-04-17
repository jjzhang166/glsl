#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 12

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 10.0;
	
	float x = v.x;
	float y = v.y;
	
	float t = time * 0.21;
	float r;
	for ( int i = 0; i < N; i+=1 ){
		float d = 3.14159265 / float(N) * float(i) * 5.0;
		r = length(vec2(x,y)) + 0.1;
		float xx = x;
		x = x + cos(y +cos(r) + d) + cos(t);
		y = y - sin(xx+cos(r) + d) + sin(t);
	}

	gl_FragColor = vec4( cos(r*0.5), sin(r*1.0), cos(r*2.0), 1.0 );

}