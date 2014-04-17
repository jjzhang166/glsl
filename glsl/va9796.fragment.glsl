#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
varying vec2 surfacePosition;

void main() {
	vec2 p=surfacePosition*32.;
	float a=length(p)+time-atan(p.y,p.x);
	gl_FragColor=sin(vec3(sin(a)-cos(a),cos(a)-sin(a),0)).xyzz;
}