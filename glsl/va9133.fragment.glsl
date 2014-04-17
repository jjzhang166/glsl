/* Colory TV Static demo "this one takes longer, and it looks trippier" */
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse; /* yes, still mouse, but it makes it seem like a moving fractal*/
uniform vec2 resolution;


void main( void ) {
 
    vec2 mousePos = mouse.xy * resolution.xy;
    vec2 pos = gl_FragCoord.xy / resolution.xy;
    
    if ((gl_FragCoord.x > abs(sin(time) * resolution.x) - 30.0) && (gl_FragCoord.x < abs(sin(time) * resolution.x) + 30.0)) {
        gl_FragColor = vec4( 1.0, 0.0, 1.0, 1.0);	
    } else {	
        gl_FragColor = vec4( 1.);
    }	
	
    //if ((mousePos.y > gl_FragCoord.y - 30.0) && (mousePos.y < gl_FragCoord.y + 30.0) && (mousePos.x > gl_FragCoord.x - 30.0) && (mousePos.x < gl_FragCoord.x + 30.0)) {
    //    gl_FragColor = vec4( sin(gl_FragCoord.x * gl_FragCoord.y), sin(gl_FragCoord.x * gl_FragCoord.y), sin(gl_FragCoord.x * gl_FragCoord.y), 1.0);	
    //} else {	
    //    gl_FragColor = vec4( 1.);
    //}
}