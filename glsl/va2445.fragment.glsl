/* Green light following your mouse. Christopher Diggins, Autodesk. */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
    // float angle = acos(dot(mouse, gl_FragCoord));
    float dist = length(mouse - (gl_FragCoord.xy / resolution.xy));
    float intensity = 0.5 - (dist);
    // Set the output color for the current pixel. 	
    gl_FragColor = vec4(
	    0.0,
	    intensity, 
	    0.0, 
	    1.0); 
}
