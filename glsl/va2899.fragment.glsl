#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float t = time * 100.0;
	vec3 d=vec3(gl_FragCoord.xy/vec2(400.0,300.0),1.);
	for(int i=0;i<100;i++) { 
		d = clamp(d, -1.0, 1.0) * 2.0 - d; 
		float r2 = dot(d, d);
		d *= t/r2;
	}
	gl_FragColor=vec4(d,1.);	

}