#ifdef GL_ES
precision mediump float;
#endif

// moire plasma by psonice

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float t = time+100.;
	vec2 p = (gl_FragCoord.xy-resolution.xy*.5)*(sin(t*0.001)*0.005+0.012);
	//t*=sin(t*0.01)*45.+55.;
	float a = 0.;
	for(float i=0.; i<5.; i++){
		p *= vec2(sin(i)*sin(p.y+t)*cos(p.x+t)*.005+.6666, cos(i)*sin(p.x+t)*cos(p.y+t)*0.005+0.6666);
		a +=  sin(p.x + t) * sin(p.y + t) > sin(p.x*t+0.)*sin(p.y*t+0.)+0.4 ? 1. : 0.;
	}
	float o = floor(a*.5);

	gl_FragColor = vec4( vec3(a=o), 1.0 );

}