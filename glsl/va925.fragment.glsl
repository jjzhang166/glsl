
#ifdef GL_ES
precision highp float;
#endif
const float pi = 3.141592653;
const float e = 2.718281828;

uniform float time;
uniform vec2 resolution;

const float mean = 240.469;
const float stddev = 15.169;
const float mark = 218.0;

const float maxY = 0.03;

float normalfunc(float x)
{
	return 1.0/sqrt(2.0*pi*stddev*stddev)*pow(e, -pow(x-mean, 2.0)/(2.0*stddev*stddev));
}

void main(void)
{
	vec4 color;
	float ratio = resolution.x/resolution.y;
	
	vec2 pxl = vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y);
	if (abs(pxl.x-0.5-tan(time/1.5*pi))*100.0*ratio < 15.0) {
		color = vec4(0.1, 1.0, 0.1, 1.0);
	}

	pxl = vec2((pxl.x-0.5)*stddev*6.0*ratio+mean, pxl.y*100.0);
	
	if (abs(pxl.y-normalfunc(pxl.x)/maxY*100.0) < 0.5) {
		gl_FragColor = color;
	}
	else if (abs(pxl.x - mark) < stddev/100.0 && pxl.y+0.5 < normalfunc(pxl.x)/maxY*100.0) {
		gl_FragColor = vec4(sin(time/0.5*2.0*pi)+0.1, sin(time/0.5*2.0*pi)+0.1, sin(time/0.5*2.0*pi)+0.1, 1.0); 
	}
	else if (pxl.x < mark-stddev/100.0 && pxl.y+0.5 < normalfunc(pxl.x)/maxY*100.0) {
		gl_FragColor = vec4(0.1+color.r, 0.1+color.g, 0.1+color.b, (217.9-pxl.x)/37.9); 
	}
	else {
		gl_FragColor = vec4(0.1); 
	}
}
