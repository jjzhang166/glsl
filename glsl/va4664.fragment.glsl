#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float x = abs(gl_FragCoord.x / resolution.x + mouse.x);

        float c = x;
	
	for (int i = 0; i < 512; i++) {
		c = atan(1e+20 * c);
        }

	gl_FragColor = vec4( c, c, c, 1.0 );
 
}