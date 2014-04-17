#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// modified by kapsy1312.tumblr.com

#define N 12

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 3.0;
	
	float x = v.x;
	float y = v.y;
	
	float t = time * 0.0021;
	float r;
	for ( int i = 0; i < N; i++ ){
		float d = 3.14159265 / float(N) * float(i) * 3.0;
		r = length(vec2(x,y)) + 0.01;
		float xx = x;
		x = x + cos(y +cos(r) + d) + cos(t);
		y = y - sin(xx+cos(r) + d) + sin(t);
	}

	gl_FragColor = vec4( cos(r*sin(time*0.01)), cos(r*cos(time*0.02)), cos(r*sin(time*0.03)), 1.0 );

}