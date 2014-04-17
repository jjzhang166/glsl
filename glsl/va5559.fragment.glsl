#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21
// Lol, this is modification of modification which actually turned all back

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

// Formula based on past performance
float AMDStockValue(float x, float i, float s) {
	return fract(sin(x+i)*10000.0)*.5*s + (1.0-gl_FragCoord.x/resolution.x)*1.*s - s*0.1;
}

float AMDLogo(vec2 p) {
	
	float y = floor((1.-p.y)*64.)-5.;
	if(y < 0. || y > 4.) return 0.;

	float x = floor((1.-p.x)*96.)-2.;
	if(x < 0. || x > 14.) return 0.;
		
	float v = 0.0;
	v = mix(v, 18990.0, step(y, 4.5)); // 011001000101110
	v = mix(v, 18985.0, step(y, 3.5)); // 100101101101001
	v = mix(v, 31401.0, step(y, 2.5)); // 111101010101001
	v = mix(v, 19305.0, step(y, 1.5)); // 100101000101001
	v = mix(v, 12846.0, step(y, 0.5)); // 100101000101110
	
	return floor(mod(v/pow(2.,x), 2.0));
}

void main( void ) {

	float d = 1e20;
	float s = 10.;
	float t = time*.08;
	
	vec2 p = gl_FragCoord.xy / resolution.xy;
	
	float z = AMDLogo(p);
	
	float x = (p.x + t*1.5 + surfacePosition.x)*s;
	float txi = floor(x+p.x-.5);
	float txf = txi-x;
	
	vec2 p0 = vec2(0.+txf, AMDStockValue(txi, 0., s));
	vec2 p1 = vec2(1.+txf, AMDStockValue(txi, 1., s));
	d = min(d, segment(p*vec2(1.0, s*1.5), p0, p1));
	
	p0 = vec2(2.+txf, AMDStockValue(txi, 2., s));
	d = min(d, segment(p*vec2(1.0, s*1.5), p1, p0));
	
	float a1 = clamp(max(d-.2, 0.0)*resolution.y/s*.5, 0.0, 1.0);
	float a0 = clamp(max(abs(d-.2)-.05, 0.0)*resolution.y/s*.5, 0.0, 8.0);
	
	p += vec2(t*1.05,-t*.7)*.5;	
	p = abs(mod(p, vec2(.08,.08))-vec2(.04,.04))-.001;
	float b = clamp(min(p.x, p.y)*resolution.y, 0.0, 1.0);
	
	gl_FragColor = vec4(z)+vec4(mix(vec3((1.-b)*.2+.2), vec3(a0*.9,a0*.05,a0*.05),(1.0-a1)), 1.0);
}