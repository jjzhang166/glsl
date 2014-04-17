/* Green light following your mouse. Christopher Diggins, Autodesk. */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
	float r = step( mod(mouse.x,0.1),0.05);
	float g = step(0.05, mod(mouse.x,0.1));
    
    // Set the output color for the current pixel. 	
    gl_FragColor = vec4(
	    r,
	    g, 
	    0.0, 
	    1.0); 
}
