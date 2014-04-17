#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;

float sdl(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);
float sline(vec2 a, vec2 b, float w);

void main( void ) {
	uv = ( gl_FragCoord.xy / resolution.xy );

	gl_FragColor = vec4( sline(vec2(.5), mouse, .005));
}

float line(vec2 a, vec2 b, float w){
	return step(sdl(a, b), w);
}

float sline(vec2 a, vec2 b, float w){
	return smoothstep(w, 0., sdl(a, b));
}

float sdl(vec2 a, vec2 b){
	float d;
	vec2 n, l;
	
	d = distance(a, b);
	n = normalize(b - a);
	l.x = max(abs(dot(uv - a, n.yx * vec2(-1.0, 1.0))), 0.0);
	l.y = max(abs(dot(uv - a, n) - d * 0.5) - d * 0.5, 0.0);
	
	return l.x+l.y;
}//sphinx