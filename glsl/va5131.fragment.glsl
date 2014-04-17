//rh2 hack 
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


//edit the text here:
//numbers after "?" are bit switches IE: 1.0=leftmost bit, 1024 is the 10th bit from the left. Summing them will turn on the leftmost bit and the bit 10 spaces to the right.
float pp( vec2 v ) {
	return v.x<0.0?0.0:floor(2.0*fract((v.y<0.?0.:v.y<1.?3745.:v.y<2.?1698.:v.y<3.?2276.:v.y<4.?3759.:0.)/(pow(2.0,floor(v.x)))));
}

float rand (float x) {
	return fract(sin(x * 4.63) * 0.342);
}

float wave (vec2 p, vec2 dir, float size) {
	dir += vec2(rand(size)) - vec2(0.5);
	return sin(dot(p, dir) / (size + rand(size)) + time*(20.0/size)) * (size + rand(size))/2.0 + 1.4;
}

float f(in vec2 p ){
	p += vec2(sin(time*0.2), cos(time*0.3));
	p *= 20.0;
	
	float res = 10.0;
	//res += wave (p, vec2(0.23, 1.0), 8.0);
	//res += wave (p, vec2(-1.27, -1.0), 20.0);
	//res += wave (p, vec2(0.23, -1.0), 7.0);
	//res += wave (p, vec2(0.21, 1.0), 11.0);
	//res += wave (p, vec2(1.29, 0.0), 10.0);
	//res += wave (p, vec2(-1.26, 0.0), 5.0);
	//res += wave (p, vec2(-1.27, 1.0), 19.0);
	//res += wave (p, vec2(1.24, 1.0), 13.0);

	//res += wave (p, vec2(0.0, 1.25), 5.2);
	//res += wave (p, vec2(-1.0, -1.21), 4.0);
	//res += wave (p, vec2(0.0, -1.28), 2.5);
	//res += wave (p, vec2(0.0, 1.24), 4.5);
	//res += wave (p, vec2(1.0, 0.22), 2.0);
	//res += wave (p, vec2(-1.0, 0.24), 2.4);
	//res += wave (p, vec2(-1.0, 1.29), 2.0);
	//res += wave (p, vec2(1.0, 1.29), 3.6);
	
	return clamp(res * 0.03, 0.0, 1.0);
}
float fmo(in vec2 p)
{
	float fppx = fract(p.x);
	float fpmx = fract(-p.x);
	float fppy = fract(p.y);
	float fpmy = fract(-p.y);
	float ppx = pp(p+vec2(1.0,0.0));
	float pmx = pp(p+vec2(-1.0,0.0));
	float ppy = pp(p+vec2(0.0,1.0));
	float pmy = pp(p+vec2(0.0,-1.0));
	const float blur = 0.5;
	return clamp(
		+ max(fppx * ppx - blur, 0.0) + max(fpmx * pmx - blur, 0.0)
		+ max(fppy * ppy - blur, 0.0) + max(fpmy * pmy - blur, 0.0)
		+ max((1.0-sqrt(pow(fpmx,2.0) + pow(fpmy,2.0)))* pp(p+vec2(1.0,1.0)) - ppx - ppy - blur, 0.0)
		+ max((1.0-sqrt(pow(fppx,2.0) + pow(fpmy,2.0)))* pp(p+vec2(-1.0,1.0)) - pmx - ppy - blur, 0.0)
		+ max((1.0-sqrt(pow(fpmx,2.0) + pow(fppy,2.0)))* pp(p+vec2(1.0,-1.0)) - ppx - pmy - blur, 0.0)
		+ max((1.0-sqrt(pow(fppx,2.0) + pow(fppy,2.0)))* pp(p+vec2(-1.0,-1.0)) - pmx - pmy - blur, 0.0)
		, 0.0, 1.0);

}

void main( void ) {
	vec2 p = vec2( gl_FragCoord.x / resolution.x*40.0-7.5, gl_FragCoord.y / resolution.y*18.0 - 8.0);
	vec2 s = p;

	float total = 0.0;
	vec2 d = (vec2(10.5,6.0)-p)/100.0;
	float w = 1.0;
	for( int i=0; i<50; i++ ) {
		total += w*max(pp(s)*1.0, fmo(s)*1.0)*f(s);
		w *= .97;
		s += d;
	}
	total /= 40.0;
	float r = 1.5/(1.0+dot(p,p));

	gl_FragColor = vec4( vec3(total*1.0+max(pp(p)*1.0, fmo(p)*1.0)*0.7*f(p)), 1.0);
	//gl_FragColor = vec4( vec3(f(p)), 1.0);
}
