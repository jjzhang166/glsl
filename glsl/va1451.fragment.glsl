//
// first shader test - no frills mandelbrot
//
// ugglan@gmail.com
//

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


#define ITER 1000.0

vec3 mand(vec2 pos) {

	vec2 z=vec2(0.);	

	
	
	float i2 = ITER;

	float r=0.;
	float g=0.;
	float b=0.;

	for (float i=0.; i<ITER; i++) {
	
	
		float tmpx=z.x*z.x-z.y*z.y+pos.x;
		z.y = 2.*z.x*z.y + pos.y;
		z.x = tmpx;
		
		if (length(z)>2.){
			i2=i;
			r=z.x;
			g=z.y;
			b=i/ITER;
			break;
		}
		
	}
	

	
	return vec3(r,g,b);
}

void main( void ) {

	float a = min(resolution.x,resolution.y);
		
	float d = length(mouse-0.5);
	vec2 pos = (gl_FragCoord.xy*2.-resolution)/a * 4. * pow(d,2.) - vec2(0.74491,0.1);

	gl_FragColor = vec4( mand(pos), 1.0 );

}
