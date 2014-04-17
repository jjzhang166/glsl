#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float PI = 3.141592658;

// Doing the smoothstep... :)
// Lets redo via more obvious distance field approach

void main(void)
{
	vec2 pos = vec2(gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
	float rad = length(pos);
	float angle = 3.0*atan(abs(pos.x), pos.y)/PI;
	float w = rad*(min(angle,abs(angle-2.0))-0.5); // tri wings
	float s = min(0.48-rad, rad-0.1);    // segments
	float r = min(0.485-rad, rad-0.45);  // outer ring
	float i = 0.06-rad;                  // inner dot
	float d = max(i, max(r, min(s,w)));  // compose distance functions
	float g = smoothstep(0.0, 0.005, d); // threshold/aa
	
	float pulse = 0.05*abs(cos(time*2.0));
	float e = smoothstep(0.0, 0.005+pulse, d+pulse);
	
	gl_FragColor = vec4(e,g,0.0,1.0);    // colorise
}