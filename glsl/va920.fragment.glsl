#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

const float pi = 3.141592653;
const float e = 2.718281828;

float normalfunc(float x, float mean, float stddev)
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

	pxl = vec2((pxl.x-0.5)*100.0*ratio+240.0, pxl.y*100.0);
	
	if (abs(pxl.y-normalfunc(pxl.x, 240.469, 15.169)/0.03*100.0) < 0.5) {
		gl_FragColor = color;
	}
	else if (abs(pxl.x - 218.0) < 0.2 && pxl.y+0.5 < normalfunc(pxl.x, 240.469, 15.169)/0.03*100.0) {
		gl_FragColor = vec4(sin(time/0.5*2.0*pi)+0.1, sin(time/0.5*2.0*pi)+0.1, sin(time/0.5*2.0*pi)+0.1, 1.0); 
	}
	else if (pxl.x < 217.9 && pxl.y+0.5 < normalfunc(pxl.x, 240.469, 15.169)/0.03*100.0) {
		gl_FragColor = vec4(0.1+color.r, 0.1+color.g, 0.1+color.b, (217.9-pxl.x)/37.9); 
	}
	else {
		gl_FragColor = vec4(0.1); 
	}
}