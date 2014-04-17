#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float gauss(float x, float u) {
	return pow(2.718, -(x*x/2.0*u*u));
}

float rect(vec2 a, vec2 b, float u) {
	vec2 position = ( gl_FragCoord.xy / resolution.yy );
	vec2 da = a - position;
	vec2 db = b - position;
	float inside = max(0.0, -(sign(da.x * db.x) + sign(da.y * db.y)));
	float dist = 1000000.0;
	if(sign(da.y * db.y) < 0.0) {
		dist = min(dist, abs(da.x));
		dist = min(dist, abs(db.x));		

	}
	if(sign(da.x * db.x) < 0.0) {
		dist = min(dist, abs(da.y));
		dist = min(dist, abs(db.y));
	}
	dist = min(dist, length(da));
	dist = min(dist, length(db));
	dist = min(dist, length(vec2(a.x,b.y)-position));
	dist = min(dist, length(vec2(b.x,a.y)-position));
	
	return max(gauss(dist, u), min(inside,1.0));
}


vec4 drawRect(vec2 a, vec2 b, vec4 colin) {
	vec2 off = vec2(0.005,-0.005);
	float col = rect(a - off, b - off, 90000.0);
	float cols = 1.0 - rect(a + off, b + off, 1.0 / off.x);
	cols = cols + 0.2;
	if(col > 0.0001) {
		return vec4( col, 0.0, 0.0, 5.0 );
	}
	else {
		return colin * cols;
	}
}

void main( void ) {
	vec4 col = vec4(1.0, 5.0,5.0, 5.0);
	for(int i = 6; i > 0; i--) {
		vec2 off = vec2(cos(float(i)), sin(float(i)))/6.0;
		col = drawRect(vec2(0.6, 0.4) + off, vec2(0.8, 0.6) + off, col);
	}
	gl_FragColor = col;
}