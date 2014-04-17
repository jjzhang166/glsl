#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi=3.1415926535;

float quasi(vec2 pos, /*const float planewaves,*/ float stripes, float phase) {
	float theta = atan(-pos.y,pos.x);
	float r = log(length(pos));  
	float C=0.0;
	const float planewaves = 3.0;
	for(float t=0.0; t<planewaves; t++) {
		C+=cos((theta*cos(t*(pi/planewaves))-r*sin(t*(pi/planewaves)))*stripes+phase);
		C+=cos((pos.x*cos(t*(pi/planewaves))+pos.y*sin(t*(pi/planewaves)))*2.0*pi*stripes+phase);  
	}
	float c=((C+planewaves)/(planewaves*2.0));
	return c;
}
void main( void ) {

	vec2 position = ( (gl_FragCoord.xy - resolution.xy/2.0) / resolution.xy );
	float crystal = quasi(position*mouse.x*10.0,8.0,time+mouse.y);
	if(crystal < 0.5) {
		if(crystal < 0.2) {
			gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
		}
		else {
			gl_FragColor = vec4(0.1, 0.1, 0.1, 1.0);
		}
	}
	else {
		if(crystal < 0.8 && crystal > 0.7) {
			gl_FragColor = vec4(0.1, 0.1, 0.1, 1.0);
		}
		else if(crystal < 0.9) {
			gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
		}
		else {
			gl_FragColor = vec4(0.2, 0.2, 0.2, 1.0);
		}
	}
	gl_FragColor += (1.0 - crystal) * 0.4;
	// gl_FragColor = vec4(crystal < 0.5 ? 1 : 0);
}