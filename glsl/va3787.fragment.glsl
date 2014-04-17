/* Green light following your mouse. Christopher Diggins, Autodesk. */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
    float dist = 0.1;
    float intensity = 0.8 - (dist);
    // Set the output color for the current pixel. 	
    gl_FragColor = vec4(
	    0.0,
	    intensity, 
	    0.0, 
	    1.0); 
}
