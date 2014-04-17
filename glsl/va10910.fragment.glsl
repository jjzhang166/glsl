#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec2 ORIGIN = vec2(0.0);
const float PI = 3.14159;
const float HALFPI = PI/2.0;
const vec4 COLOR = vec4(0.7, 0.6, 0.0, 1.0);

float sstep(float edge, float value) {
	float SMOOTH=0.003;
	return smoothstep(edge - SMOOTH, edge + SMOOTH, value);
}

void main( void ) {
	vec2 halfRez = resolution.xy / 2.0;
	vec2 centeredPos = gl_FragCoord.xy - halfRez;
	vec2 position = centeredPos / (min(resolution.x, resolution.y) /2.0);
	// position is -1.0..+1.0 on smaller axix; 0,0 is centered
	
	float centerDist = distance(position, ORIGIN);
	
	// central disc
	float c = 1.0 - smoothstep(0.20, 0.21, centerDist);
	
	// three hazard segemnts
	float opp = position.y;
	float hyp = centerDist;
	float rot3 = sin(asin(opp/hyp) * 3.0);
	float b = smoothstep(-0.03, 0.03, rot3);
	
	float hazControlMax = 1.0 - sstep(0.88, centerDist);
	float hazControl = sstep(0.27, centerDist) * hazControlMax;
	float wingz = b * hazControl;

	gl_FragColor = COLOR * (c + wingz);

}