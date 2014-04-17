#ifdef GL_ES
precision mediump float;
#endif

#define N 25

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float weight = 0.0;
	
	for (int i = 0; i < N; i++)
	{
		float dx = sin(time / float(i + 1)) * (100.0 + 30. * sin(time)) + 500.0 + 300.0 * float(i) / float(N) - gl_FragCoord.x;
		float dy = cos(time / float(i + 1)) * (100.0 + 30. * cos(time)) + 300.0 - gl_FragCoord.y;
		weight += 2.0 / length(vec2(dx,dy));
	}
	
	gl_FragColor = vec4( vec3( weight * abs(cos(time)), weight * abs(sin(time)), weight * 1.5 * abs(sin(time)) ), 1.0 );

}