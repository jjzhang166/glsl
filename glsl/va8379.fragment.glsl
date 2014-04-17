#ifdef GL_ES
precision highp float;
#endif

const vec3 black = vec3(0x00, 0x00, 0x00);

uniform vec2 mouse;
uniform vec2 resolution;

float circle(float radius, float fuzzy, vec2 p) {
	float d = length(p);
	return 1.0 - smoothstep(radius*(1.0-fuzzy), radius*(1.0+fuzzy), d);	
}

void main(void) {
	vec2 p = (gl_FragCoord.xy-resolution.xy/2.0)/resolution.y;
	float d = length(p);
	vec2 left_eyepos = (gl_FragCoord.xy-resolution.xy/2.0)/resolution.y;
	left_eyepos.x+=0.12;
	left_eyepos.x-=mouse.x-0.5;
	left_eyepos.y-=0.12;
	left_eyepos.y-=mouse.y-0.5;
	vec2 right_eyepos = (gl_FragCoord.xy-resolution.xy/2.0)/resolution.y;
	right_eyepos.x-=0.12;
	right_eyepos.x-=mouse.x-0.5;
	right_eyepos.y-=0.10;
	right_eyepos.y-=mouse.y-0.5;

	// output vector
	vec4 o = vec4(0);
	float moe = circle(0.45, 0.01, p);
	o = vec4(1.0,1.0,1.0, moe)*moe;
	
	// outer eyes
	float left_eye_outer = circle(0.17, 0.01, left_eyepos);
	o = vec4(left_eye_outer).a*vec4(black,1.0) + vec4(1.0-left_eye_outer)*o;
	float right_eye_outer = circle(0.14, 0.01, right_eyepos);
	o = vec4(right_eye_outer).a*vec4(black,1.0) + vec4(1.0-right_eye_outer)*o;

	// eye inner
	float left_eye_inner = circle(0.16, 0.01, left_eyepos);
	o = vec4(left_eye_inner).a*vec4(1.0,1.0,1.0,1.0) + vec4(1.0-left_eye_inner)*o;
	float right_eye_inner = circle(0.13, 0.01, right_eyepos);
	o = vec4(right_eye_inner).a*vec4(1.0,1.0,1.0,1.0) + vec4(1.0-right_eye_inner)*o;
	
	// pupils
	vec2 left_eye_pupil_pos = left_eyepos;
	left_eye_pupil_pos.x -= 0.1;
	left_eye_pupil_pos.y -= mouse.y/5.0-0.15;
	float left_eye_pupil = circle(0.05, 0.01, left_eye_pupil_pos);
	o = vec4(left_eye_pupil).a*vec4(black,1.0) + vec4(1.0-left_eye_pupil)*o;
	vec2 right_eye_pupil_pos = right_eyepos;
	right_eye_pupil_pos.x -= 0.08;
	float right_eye_pupil = circle(0.05, 0.01, right_eye_pupil_pos);
	o = vec4(right_eye_pupil).a*vec4(black,1.0) + vec4(1.0-right_eye_pupil)*o;

	gl_FragColor = o;
}