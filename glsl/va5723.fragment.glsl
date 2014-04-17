#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash(float n) { return fract(sin(n)*1e5); }

float snoise(vec3 p)
{
	const vec3 d = vec3(1.,30.,30.*30.);

	vec3 f = fract(p);
	float n = dot(floor(p),d);
	f = f*f*(3.0-2.0*f);
	return mix(mix(mix(hash(n), hash(n+d.x),f.x),
		       mix(hash(n+d.y), hash(n+d.x+d.y),f.x), f.y),
		   mix(mix(hash(n+d.z), hash(n+d.x+d.z),f.x),
		       mix(hash(n+d.y+d.z), hash(n+d.x+d.y+d.z),f.x), f.y), f.z);
}

vec3 helper(float d, float r, vec2 p, float s, float f) {
    float a = acos(d / r) - 3.141592 / 2.0;
    vec2 tp = vec2(a * p.x / d, a * p.y / d) * s;
    tp += vec2(snoise(vec3(tp, time)), snoise(vec3(tp, time+10.3))) * 0.4;
    tp += vec2(time * 2.0, 0.0);
    float n = snoise(vec3(tp, time*f + s + f));
    return vec3(0.5+n*1.7, n*1.5+0.12, n*1.2);
}

void main( void ) {
  vec2 p = gl_FragCoord.xy / resolution.y * 2.0 - vec2(resolution.x / resolution.y, 1.0);
  float r = 1.0;
  float d = length(p);
  vec3 c = helper(d, r, p, 6.0, 1.0) + helper(d, r, p, 8.0, 1.0);
  gl_FragColor = vec4((2.-c)*max(d-1., 0.) + c*max(1.-d, 0.)*.5, 1.0);
}
