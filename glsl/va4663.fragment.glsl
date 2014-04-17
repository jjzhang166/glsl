#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float x = abs(gl_FragCoord.x / resolution.x + mouse.x);

        float c = x;
	float zero = 1e-30*(x - x);
	float nan = zero/zero;
	
	for (int i = 0; i < 512; i++) {
		c += 1.0/ (1e-10 + c);
        }

	gl_FragColor = vec4( c, c, c, 1.0 );
 
}