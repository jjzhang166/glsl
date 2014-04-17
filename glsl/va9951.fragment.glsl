#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;

float sdfLine(vec2 a, vec2 b, float w);
float line(vec2 a, vec2 b, float w);

void main( void ) {
	float rmin = min(resolution.x, resolution.y);
	float rmax = max(resolution.x, resolution.y);
	vec2 aspect = vec2(rmin/rmax);
	vec2 uv = ( gl_FragCoord.xy / aspect) ;

	uv.x += time * .05;
	
	const int s = 1;
	float r;
	for(int i = 0; i < s; i++){
		uv.x = fract(uv.x*2.);
	}

	uv = step(.33, uv) - step(.66, uv);
	
	gl_FragColor =.5 * r - vec4(uv, 0., 0.); //huh...
}

float sdfLine(vec2 a, vec2 b, float w){
	float d0,d1,l;
	
	vec2  d = normalize(b - a);
	
	l  = distance(a, b);
	d0 = max(abs(dot(uv - a, vec2(-d.y, d.x))), 0.0),
	d1 = max(abs(dot(uv - a, d) - l * 0.5) - l * 0.5, 0.0);
	
	d0 = clamp(d0, 0., 1.);
	d1 = clamp(d1, 0., 1.);
	
	return pow(length(vec2(d0, d1)), w);
}

float line(vec2 a, vec2 b, float w){
	float l = sdfLine(a,b,w);
	return step(l,w);
}