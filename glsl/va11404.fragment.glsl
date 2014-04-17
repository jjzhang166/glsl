#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

const float PI = 3.141592658;
const float TAU = 2.0 * PI;
const vec4 blue= vec4(1,1,0,1);

// Doing the smoothstep... :)

void main(void)
{
	vec2 pos = vec2(gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
	float rad = length(pos);
	float angle = atan(pos.y, pos.x);
	float ma = mod(angle, TAU/3.0);
	float f = smoothstep(.1, .105, rad);
	gl_FragColor = mix(vec4(0, 0, 0, 1), blue, smoothstep(PI/3.0, (PI/3.0)-.01, ma) * smoothstep(.0, .02, ma) * f);
	gl_FragColor = mix(gl_FragColor, blue, smoothstep(0.45, .455, rad) + smoothstep(0.06, .055, rad) ) ;
	gl_FragColor = mix(gl_FragColor, vec4(0, 0, 0, 1), smoothstep(0.48, .49, rad));
}