#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;

const int max_iter = 100;

vec2 get_pos() {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	pos.x *= resolution.x / resolution.y;
	return pos;
}

void main( void ) {
	float x = 0.0;
	float y = 0.0;

	float betrag = 0.0;
	
	float cx = get_pos().x * (1.0 / mouse.x);
	float cy = get_pos().y * (1.0 / mouse.x);
	
	
	float xt;
	float yt;
	
	int i;
	
	for(int i = 0; i < max_iter ;i++) {
		xt = x * x - y * y + cx;
		yt = 2.0 * x * y + cy;
		x = xt;
		y = yt;
		betrag = x * x + y * y;
	}
	
	float punkt_iter = float(i) - log(log(betrag) / log(4.0)) / log(2.0);
	
	if( punkt_iter > 319.0) {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);	
	}
	
	
	
	
}