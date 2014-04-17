#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rectal(vec2 pos, vec2 start, vec2 end) {
	if (pos.x >= start.x && pos.y >= start.y && pos.x <= end.x && pos.y <= end.y) {
		return sin(distance(pos,start)*time/250.);
	} else {
		return 0.;
	}
}
		

void main( void ) {
	float r = sin(time);
	float g = cos(time);
	float b = abs(1.0-sin(time));
	
	vec2 sq1;
	sq1.x = 0.25*resolution.x;
	sq1.y = 0.25*resolution.y;
	
	vec2 sq2;
	sq2.x = 0.75*resolution.x;
	sq2.y = 0.75*resolution.y;
	
	float howmuch = rectal(gl_FragCoord.xy, sq1, sq2);
	
	gl_FragColor = vec4(r*howmuch, g*howmuch, b*howmuch, 1.);
}