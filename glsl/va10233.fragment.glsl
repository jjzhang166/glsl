#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float boxDim = 250.0;
const float boxSmooth = 3.0 / 2.0;

const float gridShift = boxDim / 49.0;
const float lineWidth = 0.1;
const float lineSmooth = 0.05;

const vec4 bgcolor = vec4(0, 0, 0, 0);
const vec4 boxcolor = vec4(0, 0, 0.6, 1);
const vec4 boxhighcolor = vec4(0.0, 0.2, 0.8, 1);
const vec4 linecolorlow = vec4(0.8, 0.7, 0, 1.0);
const vec4 linecolorhigh = vec4(1, 1.0, 0, 1.0);


float lineSelect(float d) {
	return smoothstep(0.0, lineSmooth, d) - smoothstep(lineSmooth + lineWidth, lineSmooth + lineWidth + lineSmooth, d);
}

float boxSelect(float d) {
	return smoothstep(-boxDim - boxSmooth, -boxDim + boxSmooth, d) 
		- smoothstep(boxDim - boxSmooth, boxDim + boxSmooth, d);
}

float gridbgSelect(float x, float y) {
	x -= boxDim/2.3;
	y -= boxDim/1.9;
	return smoothstep(0.0, boxDim*1.6, sqrt(x*x + y*y));
}

void main( void ) {
	gl_FragCoord.xy;

	vec4 color = bgcolor;

	// move origin to center of screen
	float x = gl_FragCoord.x - resolution.x/2.0;
	float y = gl_FragCoord.y - resolution.y/2.0;
	
	// Tilt view slightly to the right
	x = x - y * 0.2;
	
	// compute the grid background color
	vec4 gridBgColor = mix(boxhighcolor, boxcolor, gridbgSelect(x, y));
	
	// Create grid highlight lines
	float panelX = fract(4.05 * (x + gridShift)/boxDim);
	float panelY = fract(3.99 * (y + gridShift)/boxDim);
	float cSelX = lineSelect(panelX);
	float cSelY = lineSelect(panelY);
	vec4 linecolor = mix(linecolorhigh, linecolorlow, gridbgSelect(x, y));
	color = mix(gridBgColor, linecolor, max(cSelX, cSelY*cSelY));
	
	// Restrict to a subset of the screen
	float insideSel = boxSelect(x);
	float insideYSel = boxSelect(y);
	color = mix(bgcolor, color, insideSel * insideYSel);
	
	gl_FragColor = color;

}