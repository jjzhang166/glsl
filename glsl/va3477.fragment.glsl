#ifdef GL_ES
precision mediump float;
#endif

// Early morning partycoding by Kabuto

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float density(vec3 v) {
	float sum = -10.;
	float factor = 1.;
	vec3 v0 = v;
	float q = 2.;
	for (int i = 0; i < 3; i++) {
		vec3 v3 = abs(fract(v)-.5);
		v3 = max(v3,v3.yzx);
		sum = max(sum,(min(min(v3.x,v3.y),v3.z)-.25)*factor);
		v *= mat3(
0.11651722197701599,0.3544947103881083,0.9277700347012776,
-0.10673931989767256,-0.9242528744643419,0.3665560552387368,
0.9874363040574016,-0.14173963578072568,-0.06985285304270773)*q;
		v.x += sin(v.z)*.3;
		v.y += sin(v.x)*.3;
		v.z += sin(v.y)*.3;
		factor /= q;
	}
	return sum;
}

void main( void ) {
	vec3 pos = vec3(mouse.x-.5,mouse.y-.5,time)*.3;
	vec3 dir = normalize(vec3(( gl_FragCoord.xy / resolution.xy ) - .5, 1.));
	float totaldist = 0.;
	for (int i = 0; i < 200; i++) {
		float dist = density(pos);
		pos += dir*dist;
		totaldist += dist;
		dir = normalize(dir-.9*vec3(pos.xy,0.)*dist+vec3(sin(pos.z),cos(pos.z),0)*dist*.3);
	}
	float d = 0.01;
	float de = density(pos);
	vec3 norm = normalize(vec3(
		density(pos+vec3(d,0,0))-de,
		density(pos+vec3(0,d,0))-de,
		density(pos+vec3(0,0,d))-de
	));
	
	gl_FragColor = vec4(norm*.5+.5,1.)*exp(-totaldist*.1);
}