/* Bands of the color green by Christopher Diggins, Autodesk. */

#ifdef GL_ES
precision mediump float;
#endif
 
void main(void) {
    // Get a value between -1.0 and 1.0 based on X coordinate
    // Dividing by 50.0 increases the width of the stripes.
    // The gl_FragCoord predefined input variable contains the
    // coordinates of the current pixel whose color is being computed.
    float PI = 3.14159265358979323846264;
    float val = sin(gl_FragCoord.x*(PI/180.0));
    // Adjust the value to the range of 0.0 to 1.0
    val = (val / 2.0) + 0.5;

    // Dim the intensity
//    val *= 0.5;

    gl_FragColor = vec4(0.0,val,0.0,1.0);
		
}