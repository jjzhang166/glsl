#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;

float hash(vec2 v);
float sdl(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);
float sline(vec2 a, vec2 b, float w);
vec2 rotate(vec2 v, float ang);


void main( void ) {
	uv = (gl_FragCoord.xy / resolution.x) * 2.0 - vec2(1.0, resolution.y / resolution.x);
	vec2 m = 1. - 2. * mouse;
	uv /= 1.-length(uv);

	float l,f;

	vec2 p = vec2(.5);
	for (int i = 0; i < 128; i++){
		uv = rotate(uv, time*.004);
		p = rotate(p/length(p), hash(p*l)) + min(0.,sin(.25*time)*f);
		
		f = sdl(p, m);
		l += smoothstep(0.0009, .0008, f*.5);
		
	}
	
        vec4 c;
	float cs = atan(uv.x, uv.y);
	c.r = cos(cs);
	c.g = sin(cs);
	c.b = -sin(.5+cs);
	
	
	gl_FragColor = l*c;
	
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
}

float hash(vec2 v)
{
    return fract(sin(dot(v.xy+mouse.x, vec2(3.4352,6.4321))) );
}

vec2 rotate(vec2 v, float ang)
{
	mat2 m = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	return m * v;
}

//sphinx - some lines