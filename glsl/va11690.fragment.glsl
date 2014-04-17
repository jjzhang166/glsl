#ifdef GL_ES
precision mediump float;
#endif

// Kasten says:
// - Clean it up, is this what your looking for? Red bottom left, Green top right?
// Anonymous says:
// - HELP Please! I don't understand why pos isn't scaled 0 to 1
// - based on the box which should show col.g for the upper/right edge.

uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy; // position of our pixel, with vec2(0.0, 0.0) centred
        vec3 color; // col is the colour we'll return


	// red/green border to box

	if (pos.x < .5) { color.r = 1.0; }
	if (pos.x > .5) { color.b = 1.0; }

	
	gl_FragColor = vec4(color, 1.0); // return the colour
}