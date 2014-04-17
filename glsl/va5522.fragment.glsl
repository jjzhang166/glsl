#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 resolution;

float segment(vec2 P, vec2 P0, vec2 P1)
{
	vec2 v = P1 - P0;
	vec2 w = P - P0;
	float b = dot(w,v) / dot(v,v);
	v *= clamp(b, 0.0, 1.0);
	return length(w-v);
}

vec2 hash2D( float n ) { 
	float x = sin(n);
	return fract(vec2(x*10000.0, x*100000.0));
}

void main( void ) {
	
	vec2 p = gl_FragCoord.xy / resolution.xy;	
	float a = 1e20;
	
	float ti = floor(time);
	float tf = fract(time);
	
	vec2 p0 = hash2D(1.0+ti);
	vec2 p1 = hash2D(2.0+ti);
	vec2 t0 = mix(p0, p1, fract(tf));
	for(float i=1.0; i<20.0; i+=1.0) {
		vec2 p2 = hash2D(i+ti+2.0);
		vec2 t1 = mix(p1, p2, fract(tf));
		a = min(a, segment(p, t0, t1));
		p1 = p2;
		t0 = t1;
	}
	
	float a1 = max(a-.02, 0.0)*resolution.y;
	a = (abs(a-.02)-.001)*resolution.y;
	
	gl_FragColor = vec4(a1,a1,a, 1.0);
}