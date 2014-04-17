#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float scale(float min1, float max1, float min2, float max2, float val1) {
	return (min1-val1)/(max1-min1)*(max2-min2);
}

float minX = -2.0;
float maxX = 1.0;
float minY = -1.2;
float maxY = minY+(maxX-minX)*resolution.y/resolution.x;
const int maxIt = 200;

void main( void ) {
	float y0 = scale(0.0, resolution.y, minY, maxY, gl_FragCoord.y);
	float x0 = scale(0.0, resolution.x, minX, maxX, gl_FragCoord.x);
	float Z_re = x0;
	float Z_im = y0;
	float l;
	for(int n = 0; n<maxIt; ++n) {
		float Z_re2 = Z_re*Z_re;
		float Z_im2 = Z_im*Z_im;
		if(Z_re2 + Z_im2 >4.0){break;}
		float Z_im = 2.0*Z_re*Z_im + y0;
		float Z_re = Z_re2 - Z_im2 + x0;
		l = float(n);
	}
	
	if(l<float(maxIt)-1.0){gl_FragColor = vec4(1.0,0.0,0.0,0.0);}
}