#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 5.0

void main( void ) {

	vec2 position = ( gl_FragCoord.xy ) + time / 10.0;
	float color1 = 0.;
	float color2 = 0.;
	float color3 = 0.;

	for(float i = 0.0; i < N; i++) {
	  	float a = i * (TWO_PI/N) *(time+9.0)*0.01;
		color1+= cos( ((position.x-resolution.x/1.) * cos(a) + (position.y-resolution.y/2.) * sin(a) + time*2.) * 0.1);
		color2 = color1/time;
		color3 = color2;
	}
	

	//color1/= 2.0;
	//color2/= 1.0;
	//color3/= 5.;
	
	//color1 = position.x *cos(time);
	gl_FragColor = vec4(color1, color2, color3, 1.0 );

}