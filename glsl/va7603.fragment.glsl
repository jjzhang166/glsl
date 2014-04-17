#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 colorProportion = vec3(100.0,40.0,10.0);

	float c = 0.0;
	c += position.x+0.4;
	
	for(int i = 0; i < 2; i++) {
		float a = 0.3/(sin(position.x + cos(time/1000.0)*time*(float(i+1)/5.0) )/14.0 + position.y-0.8+(0.02*float(i)));
		if(a < 0.1) {
			a /= 10.0;
			c += sqrt(a);
		}
	}
	for(int i = 0; i < 2; i++) {
		float a = 0.3/(sin(position.x + cos(time/1000.0)*time*(float(i+1)/4.0) )/13.0 + position.y-0.3+(0.02*float(i)));
		if(a > 0.1) {
			a /= 10.0;
			c += sqrt(a);
		}
	}
	c = pow(c,2.0);
	
	gl_FragColor = vec4( vec3(c/colorProportion.r,c/colorProportion.g,c/colorProportion.b), 1.0 );
}