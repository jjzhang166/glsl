#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float col(float x) { 
	return (sin(x));
	if (x>0.5)  { return 1.0; }
	else { return 0.0; } 
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy )*16.;

	float color = 0.0;
        float c = col((position.x)); 
	gl_FragColor = vec4( vec3(c), 1.0 );

}