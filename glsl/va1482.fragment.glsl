#ifdef GL_ES
precision mediump float;
#endif

// Hyperbolic noise by Kabuto

// This is a perlin noise generator modified to operate on the hyperbolic plane (using the poincare metric but it's easily converted to other hyperbolic metrics)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// PRNG - turned out to be much better than the "mod 289" one
float random(float r) {
     return mod(floor(fract(r*0.1453451347234+0.7)*fract(r*0.7824754653+0.3)*6345.+fract(r*0.284256563424)*7254.),256.);
}

// Generates one stripe of perlin noise, ready to be combined with another stripe
float sperlin(float x, float y, float l, float r) {
	float xf = floor(x);
	x -= xf;
	float x0 = y+random(xf+r);
	float x1 = y+random(xf+r+1.);
	float a = (random(x0)-127.5)*x	 + (random(x0+128.)-127.5)*l;
	float b = (random(x1)-127.5)*(x-1.) + (random(x1+128.)-127.5)*l;
	return (a+(x*x*(3.-2.*x))*(b-a))/256.;
}

// 2D hyperbolic perlin noise - combines 2 stripes of 1D perlin noise
// x3,y3: coordinate within the unit disc (poincare metric)
// ntime: time (used to shift everything along the y axis without causing artifacts that easily occur when zooming the border instead)
// f: noise scale factor - 1 = coarse, < 1 = fine. Don't use > 1 as that gives artifacts
// r: PRNG offset (to get different noise in case you need multiple layers)
float hypperlin(float y3,float x3,float ntime,float f,float r) {
	ntime /= f;
	
	float div = (1.-x3*x3-y3*y3);

	float x = x3 * 2./div;
	float y = y3 * 2./div;
	float z = (1.+x3*x3+y3*y3)/div;
	
	float ttime = floor(ntime);
	ntime -= ttime;
	ntime *= f;

	float v = (log(z+y)+ntime)/f;
	float s = x*(z-y)*exp(-ntime)/(x*x+1.);
	
	float v2 = floor(v);
	float l = v-v2;
	float xc = s*exp(v2*f)/f;
	float s2 = sperlin(xc,v2+ttime,l,r);
	float s3 = sperlin(xc*exp(f),v2+ttime+1.,l-1.,r);
	
	return s2+(s3-s2)*((6.*l-15.)*l+10.)*l*l*l;
}

void main( void ) {
	float x = (gl_FragCoord.x * 2. - resolution.x ) / resolution.y;
	float y = gl_FragCoord.y / resolution.y * 2. - 1.;
	const float scale = 1.;//exp(mouse.x*1.5-0.75);
	if (x*x+y*y < 1.) {
		
		float h = (
			abs(hypperlin(x,y,time,scale*0.5,0.))*0.5+
			abs(hypperlin(x,y,time,scale*0.25,44.))*0.25+
			abs(hypperlin(x,y,time,scale*0.125,35.))*0.125+
			abs(hypperlin(x,y,time,scale*0.0625,16.))*0.0625+
			abs(hypperlin(x,y,time,scale*0.03125,7.))*0.03125
		)*16.;
		float c1 = (hypperlin(x,y,time,scale,111.)+.3)*h;
		float c2 = (hypperlin(x,y,time,scale,21.)+.3)*h;
		float c3 = (hypperlin(x,y,time,scale,3.)+.3)*h;
		gl_FragColor = vec4(c1,c2,c3,.5);
	} else {
		gl_FragColor = vec4(.5,.5,.5,1.);
	}
}