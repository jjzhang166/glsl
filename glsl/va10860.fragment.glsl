#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const bool glow = true;

const vec4 BULBC = vec4( 0.8, 0.8, 0.0, 1.0 );
const vec4 BASEC = vec4( 0.6, 0.6, 0.6, 1.0 );
const vec4 GLOWC = vec4( 0.9, 0.9, 0.9, 1.0 );

float sstep(float edge, float value) {
	float SMOOTH=0.003;
	return smoothstep(edge - SMOOTH, edge + SMOOTH, value);
}

float bulbSelector(vec2 position, float bellRadius) {
	// Bell
	float bulbC = 1.0 - sstep(bellRadius, distance(position, vec2(0.0, 0.21)));

	// Curved edges
	float lside = sstep(atan(-1.9 * position.y * 3.1415 * 0.5) * 0.2, 0.35 + position.x);
	float rside = sstep(atan(-1.9 * position.y * 3.1415 * 0.5) * 0.2, 0.35 - position.x);
	float curveVert = 1.0 - max(step(0.0, position.y), 1.0 - sstep(-0.401, position.y));
	float curveC = min(min(rside, lside), curveVert);
	
	return max(bulbC, curveC);
}

float baseSelector(vec2 position) {
	// Base
	float baseVert = max(step(-0.4, position.y), 1.0 - step(-0.82, position.y));
	float baseHoriz = sstep(0.16 + (0.03 * pow(abs(sin((35.0 + position.y) * 46.6)), 0.8)), abs(position.x));
	return 1.0 - max(baseHoriz, baseVert);
}


void main( void ) {
	vec2 halfRez = resolution.xy / 2.0;
	vec2 centeredPos = gl_FragCoord.xy - halfRez;
	vec2 position = centeredPos / (min(resolution.x, resolution.y) /2.0);
	// position is -1.0..+1.0 on smaller axis
	
	float bulbSel = bulbSelector(position, 0.41);
	float baseSel = baseSelector(position);

	baseSel = baseSel * (0.8 + 0.2 * sin(0.0 + (position.y * 2.0 * 46.6)));
	
	float glowSel = 0.8 - 0.8 * smoothstep(0.0, 1.0, pow(distance(position, vec2(0.0, 0.20)), 0.9));
	
	// darken the left edge slightly
	float cGrade = 0.6 + (0.4 * smoothstep(-0.3, 0.2, position.x));
	
	if (glow) {
	  cGrade = 1.0;
	} else {
	  glowSel = 0.0;
	}
	
	gl_FragColor = 
		(glowSel * GLOWC)
		+ ((BULBC * bulbSel + BASEC * baseSel) * cGrade);
}