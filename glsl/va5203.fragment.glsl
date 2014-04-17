// Posted by Trisomie21

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n)
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

int was_alive(vec2 pos) {
	return int(texture2D(backbuffer, pos/resolution).z / 0.097);
}
int was_dead(vec2 pos) {
	return int(texture2D(backbuffer, pos/resolution).r / 0.00187);
}

void main( void ) {

	vec2 pos = gl_FragCoord.xy;
	
	int alive;
	int dead;
	
	if (mouse.x < 0.1) {
		alive = nrand(pos*0.01 + vec2(time,time)) < 0.5 ? 1 : 0;
	} else {
		int c =
			(was_alive(pos + vec2( 0, 1)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2( 0,-1)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2( 1, 1)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2( 1, 0)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2( 1,-1)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2(-1, 1)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2(-1, 0)) > 0 ? 1 : 0) +
			(was_alive(pos + vec2(-1,-1)) > 0 ? 1 : 0);
		if (c > 3 || c < 2) alive = 0;
		else if (c == 3) alive = was_alive(pos) + 1;
		else {
			int w = was_alive(pos);
			if (w > 0) ++w;
			alive = w;
		}
		if (alive > 0) dead = 0;
		else dead = was_dead(pos) + 1;
	}
	if (alive > 10) alive = nrand(pos*0.1 + vec2(time, time*0.3)) > 0.0001 ? 10 : 0;
	if (dead > 500) {
		if (nrand(pos*0.1 + vec2(time * 0.3, time)) > 0.0000001) {
			dead = 0;
			alive = 1;
		}
	}
	
	gl_FragColor = float(alive) * 0.1 * vec4(0,0,1,0) + float(dead) * 0.002 * vec4(1,0,0,1);
}