#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
varying vec2 surfacePosition;

vec3 nn(vec2 p) {
	p *= 10.0;
	p = mod(p, 3.0);
	p -= vec2(1.0,1.0);
	if (length(p) > 1.0) return vec3(0,0,0);
	return vec3(p.x, p.y, sqrt(1.0-p.x*p.x-p.y*p.y));
}

void main() {

vec2 pos = surfacePosition.xy;
vec2 mpos = mouse.xy * 2.0 - vec2(1.0);
vec3 n = nn(pos);
vec3 l = vec3(mpos.xy,0.3) - vec3(pos.x, pos.y, 0);
vec4 c1 = dot(n,l) * vec4(0.8,0.8,1,1) + vec4(0.1,0,0,1);
float a = max(0.0,1.0-length(mpos - pos)/0.3);
vec4 c2 = vec4(a,a,a,0);
gl_FragColor = c1 + c2;

}