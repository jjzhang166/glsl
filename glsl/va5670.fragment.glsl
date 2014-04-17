#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

float segment(vec2 P, vec2 P0, vec2 P1)
{
	vec2 v = P1 - P0;
	vec2 w = P - P0;
	float b = dot(w,v) / dot(v,v);
	v *= clamp(b, 0.0, 1.0);
	return length(w-v);
}

float Amp(float x, float s)
{
	float f = clamp(x/s+.5, 0.0, 1.0);
	return ((fract(sin(x+time * 0.00005)*1e5))-.5)*f*(1.0-f)*s;
}

vec3 Wave(vec2 p)
{
	float s = 30.;

	p = p*s;
	
	float x = floor(p.x);
	
	vec2 p0 = vec2(x-.5, Amp(x-.5, s));
	vec2 p1 = vec2(x+.5, Amp(x+.5, s));
	float d = segment(p+vec2(0,0), p0, p1);
	
	p0 = vec2(x+1.5, Amp(x+1.5, s));
	d = min(d, segment(p+vec2(0,0), p1, p0));
	
	float a1 = clamp(max(d-.2, 0.0)*s, 0.0, 1.0);
	float a0 = clamp(max(abs(d-.2)-.05, 0.0)*s, 0.0, 4.0);

	p = abs(mod(p, vec2(1.,1.))-vec2(.5,.5))-.01;
	float b = clamp(min(p.x, p.y)*resolution.x/s, 0.0, 1.0);
	
	return vec3(mix(vec3((1.-b)*.2+.2)*.2, vec3(a0*.6,a0*.3,a0),(1.0-a1)));
}
		    

void main(void)
{
	gl_FragColor = vec4(Wave(surfacePosition*(resolution.y/resolution.x)), 1.0);
}
