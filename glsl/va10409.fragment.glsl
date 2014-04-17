#ifdef GL_ES
precision highp float;
#endif

uniform vec3 unResolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D text1;
uniform sampler2D fft;
uniform vec4 unPar;
uniform vec4 unPos;
uniform vec3 unBeatBassFFT;

float iSphere( in vec3 ro, in vec3 rd ) {
	float r = 1.0;
	float b = 2.0*dot( rd, rd );
	float c = dot(ro, ro) - r*r;
	float h = b*b - 4.0*c;
	if( h<0.0 ) return -1.0;
	float t = (-b - sqrt(h))/2.0;
	return t;
}

float intersect( in vec3 ro, in vec3 rd) {
	float t = iSphere( ro, rd );
	return t;
}

void main( void ) {

	gl_FragColor = vec4(cos(gl_FragCoord.xyx/100.0), 1.0);
}