#ifdef GL_ES
precision mediump float;
#endif

// fernlightning - New Zealand
//
// reference image http://www.newzealandfireextinguishers.co.nz/files/3073706/uploaded/nz-flag1.jpg

uniform float time;
uniform vec2 resolution;

// basic colors
const vec4 red  = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 blue = vec4(0.0, 0.0, 0.5, 1.0);
const vec4 white = vec4(1.0);




float penta(vec2 coords, float size) {
    float a = atan(coords.x, coords.y);
    a = abs(sin(a*2.5));
    a = 0.5/(0.4+0.6*a);	
    return a*size - length(coords);
}

vec4 star(vec2 x, float size) {
    float a = penta(x, size);
    float b = penta(x, size-4.0);
    vec4 c = mix(vec4(0.0), red, a);
    c = mix(white, c, clamp(a*b, 0.0, 1.0));    	
    return clamp(c, 0.0, 1.0);	
}

float rect(vec2 x, vec2 d) {
    vec2 e = abs(x)-d;
    return clamp(1.0-max(e.x, e.y), 0.0, 1.0);
}

float cross(vec2 x, vec2 d) {
    vec2 e = abs(x)-d;
    return clamp(1.0-min(e.x, e.y), 0.0, 1.0);
}

float diag(vec2 x, vec2 d, vec2 offset) {
    vec2 e = abs(abs(x.x+sign(x.y)*offset.x)-abs(x.y*1.5)-sign(x.x*x.y)*offset.y)-d; // 1.5 is aspect ratio of flag
    return clamp(1.0-min(e.x, e.y), 0.0, 1.0);
}

vec2 wave(vec2 pos) {
    //return vec2(0.0); // no wave
    float t = time+pos.x*0.03;
    return vec2(sin(t), cos(t) + pos.x * 0.02);
}

void main( void ) {
	vec2 opos = (gl_FragCoord.xy/resolution.xy - 0.5)*600.0;
	opos.y *= resolution.y/resolution.x;
	
	vec2 anchor = vec2(-150.0, -100.0);
	vec2 pos = opos + (wave(opos)-wave(anchor))*10.0;
	
	vec4 background = rect(pos, vec2(150.0, 100.0))*blue;
	
	vec2 spos = pos-vec2(75.0, 65.0);
	vec4 stars = star(spos, 14.0) + star(spos+vec2(35.0, 45.0), 14.0) + star(spos+vec2(-35.0, 45.0), 14.0) + star(spos+vec2(0.0, 120.0), 16.0);
	vec4 c = mix(background, stars, stars.a); // mix
	
	vec2 jpos = pos-vec2(-75.0, 50.0);
	float w = cross(jpos, vec2(20.0, 20.0));
	float wd = diag(jpos, vec2(20.0, 20.0), vec2(0.0, 4.0))*(1.0-w); // crop to w
	float r = cross(jpos, vec2(11.0, 11.0));
	float rd = diag(jpos, vec2(8.0, 8.0), vec2(4.0))*(1.0-w); // crop to w
	vec4 jack = ((w+wd)-(r+rd))*white + (r+rd)*red;	
	c = mix(c, jack, jack.a*rect(jpos, vec2(75.0, 50.0))); // mix and crop to rect

	c = c * (0.7 + 0.3*wave(pos).x); // quick and dirty lighting 
	
	vec4 staff = rect(opos - vec2(-165.0, -100.0), vec2(10.0, 200.0))*white;
	c += staff;
	
	gl_FragColor = c;
}
