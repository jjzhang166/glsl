#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// like a space harrier.

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;

	float y = position.y - mouse.y;
	float yy = abs(y);
	if (y > 0.0) {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
		// enable this "return" statement not to draw the ceiling
	//	return;
	} 
	
	y /= (mouse.y ) ;
	
	float z = 1.0 / yy;
	float x = (position.x - 0.5) / yy;
	float color = 0.0;
	if (sin(z * 8.0 + time* 20.0) > 0.0) {
		color += 0.5;
	} else {
	}
	if (sin(x * 20.0 + time * (mouse.x - 0.5) * 100.0) > 0.0) {
		color += 0.5;
	} else {
	}
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

	if (yy < 0.2) {
		gl_FragColor *= (yy* 5.0);
	}

}