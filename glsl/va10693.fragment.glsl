#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

// exploring the sweetspot of the julia with a twist every other iteration

#define MAX_ITER 32

void main( void ) {

	vec2 p,i = surfacePosition * 4.0;
	float c = 0.0;
	bool f = true;
	int ni = 0;	
	for (int n = 0; n < MAX_ITER; n++) {
		float t = time*0.666;
		if (!f) {
			i = vec2(
				dot(i, vec2(i.x, -i.y)) - (0.666 + (sin(t)*0.333)),
				2.0*i.x*i.y             - (0.666 + (cos(t)*0.333))
			);
			c += sqrt(dot(
					vec2(p.x-(cos(p.y-t)*5.0), -p.y-(sin(p.x-t)*5.0)),
					vec2(i.x-(sin(i.x)*5.0),  i.y-(cos(i.y)*5.0))

			));
		} else {
			i = vec2(
				dot(i, vec2(i.x, -i.y)) + (0.666 + (cos(t)*0.333)),
				2.0*i.x*i.y             + (0.666 + (sin(t)*0.333))

			);
			c += sqrt(dot(
				vec2(p.x+(cos(p.y-t)*5.0), -p.y+(sin(p.x)*5.0)),
				vec2(i.x+(sin(i.x)*5.0),  i.y+(cos(i.y)*5.0))

			));
		}
		ni++;
		if (c > float(MAX_ITER-ni))
			break;
		f = !f;
	}
	c = pow(float(ni*ni)/c, 1.5);
	
	gl_FragColor = vec4( vec3(c), 1.0 );

}