#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
    // Get a value between -1.0 and 1.0 based on X coordinate
    // Dividing by 50.0 increases the width of the stripes.
    // The gl_FragCoord predefined input variable contains the
    // coordinates of the current pixel whose color is being computed.
    float Rval = sin(gl_FragCoord.x / 100.0);
	float Gval = sin(gl_FragCoord.y / 100.0);
	float Bval = sin(gl_FragCoord.x / 100.0)*sin(gl_FragCoord.y / 100.0);

    float dist = length(mouse - (gl_FragCoord.xy / resolution.xy));
    float intensity = 0.5 - (dist);
	
    // Adjust the value to the range of 0.0 to 1.0
    Rval = (Rval / 2.0) + 0.5;
	Gval = (Gval / 2.0) + 0.5;
	Bval = (Bval / 2.0) + 0.5;
    // Dim the intensity
    Rval *= intensity;
	Gval *= intensity;
	Bval *= intensity;
	
    // Set the output color for the current pixel.    
    gl_FragColor = vec4(
           Rval,
           Gval,
           Bval,
           1.0);
}