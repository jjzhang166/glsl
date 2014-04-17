/* Bands of the color green by Christopher Diggins, Autodesk. */

#ifdef GL_ES
precision mediump float;
#endif

void main(void) {
    // Get a value between -1.0 and 1.0 based on X coordinate 
    // Why 50? Remove it. See what happens.
    float val = sin(gl_FragCoord.x / 50.0);
    // Adjust the value to the range of 0.0 to 1.0
    val = (val / 2.0) + 0.5;
    // Dim the intensity
    val *= 0.5;
    // Set the output color for the current pixel. 	
    gl_FragColor = vec4(
	    0.0,
	    val, 
	    0.0, 
	    1.0); 
}
