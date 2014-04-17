#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;
vec2 m;
vec2 hm;

float hash(vec2 v);
float sdl(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);
float sline(vec2 a, vec2 b, float w);
vec2 rotate(vec2 v, float ang);


void main( void ) {
	uv = (gl_FragCoord.xy / resolution.x) * 2.0 - vec2(1.0, resolution.y / resolution.x);
	m = 1. - 2. * mouse;
	hm = vec2(.01, .4444)+mouse*.01;
	
	uv /= 1.-length(.5*uv);

	float l,f;

	vec2 p = vec2(m);
	for (int i = 0; i < 128; i++){
		uv = rotate(uv, 512.);
		p = rotate(p/length(p), hash(p*l));
		
		f = sdl(p, m/uv)*sdl(p, m-1.);
		l += smoothstep(.019, -1., f);
		
	}
	
        vec4 c;
	float cs = .5*atan(uv.x, uv.y);
	c.r = cos(cs-1.);
	c.g = sin(cs-1.6);
	c.b = cos(cs+1.);
	c*=c;
	
	gl_FragColor = c*l*128.; //surprise!
	
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
	
	return (l.x+l.y);
}

float hash(vec2 v)
{
    return fract(sin(dot(v.xy+hm, vec2(3.4352,6.4321))) );
}

vec2 rotate(vec2 v, float ang)
{
	mat2 m = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	return m * v;
}

//sphinx - some lines