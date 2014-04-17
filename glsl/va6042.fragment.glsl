#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21 : 2D noise experiment (pan/zoom)

// failed attempt at faking caustics

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec4 textureRND2D(vec2 uv){
	uv = floor(fract(uv)*1e3);
	float v = uv.x+uv.y*1e3;
	return fract(1e5*sin(vec4(v*1e-2, (v+1.)*1e-2, (v+1e3)*1e-2, (v+1e3+1.)*1e-2)));
}

float noise(vec2 p) {
	vec2 f = fract(p*1e3);
	vec4 r = textureRND2D(p);
	f = f*f*(3.0-2.0*f);
	return (mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y));	
}

float color(vec2 p) {
	float v = 0.0;
	v += noise(p)*1.2;
	return v;
}

void main( void ) {
	vec2 p = surfacePosition*.05+.5;
	float c1 = color(p*.3+time*.0015);
	float c2 = color(p*.3-time*.0015);
	
	float c3 = color(p*.2-time*.0015);
	float c4 = color(p*.2+time*.0015);
	
	float cf = pow(c1*c2*c3*c4+0.5,6.);
	
	vec3 c = vec3(cf);
	gl_FragColor = vec4(c+vec3(0.1,0.6,1.0), 1.);
}