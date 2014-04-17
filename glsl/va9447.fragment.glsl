/* Bands of the color green by Christopher Diggins, Autodesk. */

#ifdef GL_ES
precision mediump float;
#endif

float distance(float x, float y, float stepsize) {
	float stepx = mod(x, stepsize) / (stepsize / 2.0) - 1.0;
    float stepy = mod(y, stepsize) / (stepsize / 2.0) - 1.0;
    return sqrt(stepx * stepx + stepy * stepy);
}
 
void main(void) {
    // Get a value between -1.0 and 1.0 based on X coordinate
    // Dividing by 50.0 increases the width of the stripes.
    // The gl_FragCoord predefined input variable contains the
    // coordinates of the current pixel whose color is being computed.
    
    float dist = distance(gl_FragCoord.x, gl_FragCoord.y, 10.0);
    float dist2 = distance(gl_FragCoord.x, gl_FragCoord.y, 10.3);

    float val = sin(gl_FragCoord.x / 10.0);
    float val2 = cos(gl_FragCoord.x / 13.7);

    // Adjust the value to the range of 0.0 to 1.0
    val2 = (val2 / 2.0) + 0.5;
    val = (val / 2.0) + 0.5;

    // Dim the intensity
    val *= 0.9;

    // Set the output color for the current pixel.    
    //gl_FragColor = vec4(
    //       (1.0 - dist),
    //       val * dist,
    //       (1.0-val2),
    //       1.0);
    gl_FragColor = vec4(0.4, val, (1.0 - val2), 1.0) * sqrt((1.0 - dist) * (1.0 - dist2));}