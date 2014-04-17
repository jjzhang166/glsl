#ifdef GL_ES
precision mediump float;
#endif

#define N 8

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float weight = 0.0;
	
	for (int i = 0; i < N; i++)
	{
		float dx = sin(time / float(i + 1)) * 100.0 + 200.0 + 300.0 * float(i) / float(N) - gl_FragCoord.x;
		float dy = cos(time / float(i + 1)) * 100.0 + 150.0 - gl_FragCoord.y;
		weight += 2.0 / sqrt(dx * dx + dy * dy);
	}
	
	weight = float(weight > 0.25);
	
	gl_FragColor = vec4( vec3( weight, 0.0, 0.0 ), 1.0 );

}