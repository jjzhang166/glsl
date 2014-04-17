// by davedes
// simple circle outline, not the best technique...
// /\_ another method : using pixel units for controls

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main(void) {
	
	//  desired color
	vec4 vColor = vec4(1.0, 0.8, 0.2, 1.0);
	
	// In pixel units
	float outline = 3.0;
	float softness = 0.5;
	float radius = length(mouse.xy*resolution.xy-resolution.xy*.5);
	
	float d = length(gl_FragCoord.xy-resolution.xy*.5)-radius;
	if(outline > 0.0) d = abs(d) - (outline*.5-.5);
	d = 1.0-clamp(d/(1.0+softness), 0.0, 1.0);
	
	gl_FragColor = d * vColor;
	
	return;
}