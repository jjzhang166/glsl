precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec4 color1 = vec4 (1.0, 0.8, 0.8, 1.0);
const vec4 color2 = vec4 (0.3, 0.2, 0.5, 1.0);
const float size = 0.04;
const float speed = 0.2;

/*
Maps from {-infinity, infinity}
to {0, 1}.
*/
float utils_sigmoid (float x) {
	return 1.0 / (1.0 + exp(-x));	
}

float trans (in vec2 pos) {
	vec2 coord = gl_FragCoord.xy / resolution;
	float d = length (pos - coord);
	float f = size / d;
	return f / (f - 16.0);	
}

/*
Calculates the position of a particle that bounces within a range.
Can be combined in 2D or 3D.
*/
float utils_bounce (in vec2 range, in float start, in float vel, in float time) {
	if (vel == 0.0) {
		return start;
	}
	
	float r = range.y - range.x;
	if (r == 0.0) {
		return range.x;	
	}
	
	start = (start - range.x) / r;
	vel = vel / r;
	float t0 = (1.0 - start) / vel;
	float ti = 1.0 / vel;
	float m = mod ((time - t0) / ti, 2.0);
	m = m > 1.0 ? 2.0 - m : m;
	return m * r + range.x;
}

vec2 bounce (in vec2 startPos, in vec2 startVel, in float time) {
	return vec2 (utils_bounce (vec2 (0.0, 1.0), startPos.x, startVel.x, time), 
		     utils_bounce (vec2 (0.0, 1.0), startPos.y, startVel.y, time));
}

void main( void ) {
	float f = 0.0;
	float t = time * speed;
	f += trans (bounce (vec2 (0.2305123347, 0.0176739099), vec2 (0.7963728718, 0.8514780874), t));
	f += trans (bounce (vec2 (0.5413479757, 0.4512601603), vec2 (0.9359430479, 0.5225455910), t));
	f += trans (bounce (vec2 (0.9943942183, 0.0935004216), vec2 (0.3106910990, 0.1622248976), t));
	f += trans (bounce (vec2 (0.2429376209, 0.1883747749), vec2 (0.4109957732, 0.6861682279), t));
	
	f += trans (bounce (vec2 (0.4105986911, 0.8756187913), vec2 (0.7638921726, 0.3957324678), t));
	f += trans (bounce (vec2 (0.3318642680, 0.5587692034), vec2 (0.8858068873, 0.4510628938), t));
	f += trans (bounce (vec2 (0.0834955432, 0.8689441245), vec2 (0.0102961342, 0.0473718270), t));
	f += trans (bounce (vec2 (0.4037620022, 0.0516317243), vec2 (0.9654179479, 0.1402763503), t));
	
	f += trans (bounce (vec2 (0.0957473034, 0.4753956393), vec2 (0.5189741628, 0.3802055165), t));
	f += trans (bounce (vec2 (0.2999877504, 0.9554285830), vec2 (0.9109894643, 0.9313428730), t));
	f += trans (bounce (vec2 (0.0090639283, 0.6498047274), vec2 (0.7349749744, 0.3044158035), t));
	f += trans (bounce (vec2 (0.5704076956, 0.8654245111), vec2 (0.5567773955, 0.9835711142), t));
	
	f += trans (bounce (vec2 (0.7214938692, 0.1384318185), vec2 (0.0573554457, 0.9791073499), t));
	f += trans (bounce (vec2 (0.6823569858, 0.9474067403), vec2 (0.8024851693, 0.3904940582), t));
	f += trans (bounce (vec2 (0.5092574789, 0.2629417585), vec2 (0.4214823383, 0.2553955668), t));
	f += trans (bounce (vec2 (0.0002894561, 0.7673319994), vec2 (0.4228149106, 0.1145576802), t));
	
	f = f / (f - 0.5);
	f = utils_sigmoid (f);
	
	gl_FragColor = mix (color2, color1, f);
}