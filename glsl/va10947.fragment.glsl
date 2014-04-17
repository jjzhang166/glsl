#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 colorAdj(vec4 inColor, float adj) {
	return vec4(inColor[0] + adj, inColor[1] + adj, inColor[2], inColor[3]);	
}

void main(void) {
	
	vec4 color1 = vec4(1.0, 0.5, 0.5, 1.0);
	vec4 color2 = vec4(1.0, 0.5, 1.0, 1.0);
	
	vec2 p = 1.0 - (mouse - (gl_FragCoord.xy / resolution.xy));
	
	if (p.x < 1.0 && p.y > 1.0)
		gl_FragColor = colorAdj(color1, 1.0 - p.y);
	else if (p.x < 1.0 && p.y < 1.0)
		gl_FragColor = colorAdj(color2, 1.0 - p.x);
	else if (p.x > 1.0 && p.y > 1.0)
		gl_FragColor = colorAdj(color2, 1.0 - p.x);
	else
		gl_FragColor = colorAdj(color1, 1.0 - p.y);
	
}