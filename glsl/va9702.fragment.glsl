#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float sdf(	vec2 p, vec2 uv)	;
float lsdf(	vec2 a, vec2 b, 	vec2 uv);
float circle(	vec2 p, vec2 uv, 	float r);
float line(	vec2 a, vec2 b, 	vec2 uv, float w);

vec4 lens(vec2 p);
vec4 rays(vec4 l);
vec4 sphere(vec4 l, vec2 p);
vec4 eye(vec4 l);


void main( void ) {
	vec2 p = vec2(0., -0.5) + (gl_FragCoord.xy / resolution.xy) ;
	

	vec4 light = rays(lens(p));
	
	vec4 s = sphere(light, p);
		 
	light =	eye(s);
	
	gl_FragColor = light;
}

vec4 lens(vec2 p){
	
	
	vec2 l		= p.xy * sdf(p.xy + vec2(mouse.x, 0.), mouse.x * p.xy);
	l.x += .7;
	float s		= step(p.x, 1.-l.x);
	
	return normalize(vec4(l, s, 1.));
}

vec4 rays(vec4 p){
	
	vec2 r = fract(8. * p.xy * p.y / p.y);

	float s = step(.9, r.y) * 10.;

	return normalize(vec4(r, s, 1.));
}

vec4 sphere(vec4 l, vec2 p){
	
	float r = 10.;
	vec2  o = vec2(.5, 0.);
	float s = 1.-(r * length(p - o));
	
	return normalize(vec4(fract(l.xy*s), s+l.z, 1.));
}

vec4 eye(vec4 p){
	vec2 l		= p.xy + sdf(vec2(1., 0.), p.xy - vec2(mouse.x, 0.));
	float s		= p.x + l.x;
	
	return (p);
}

float sdf(vec2 p, vec2 uv){
	return length(uv-p);
}

float lsdf(vec2 a, vec2 b, vec2 uv){
	float d0,d1,l;
	
	vec2  d = normalize(b.xy - a.xy);
	
	l  = distance(a.xy, b.xy);
	d0 = max(abs(dot(uv - a.xy, d.yx * vec2(-1.0, 1.0))), 0.0),
	d1 = max(abs(dot(uv - a.xy, d) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d0, d1));
}

float line(vec2 a, vec2 b, vec2 uv, float w){
	float l = lsdf(a,b,uv);
	return step(l,w);
}

float circle(vec2 p, vec2 uv, float r){
	return step(sdf(p,uv), r);
}

//sphinx