#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 3.14159
#define ITER 16.

//quickie with fourier series, nothing cool here, sorry. 
void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	pos-=vec2(0.5,0.5);
	pos*=4.;
	vec3 color;
	//color.r=abs(pos.x);
	//color.g=abs(pos.y);
	float f=0.;
	float iter=5.;
	for(float i=0.;i<ITER;i++){
		f+=sin((2.*i+1.)*PI*(pos.x-mouse.x*4.))/(2.*i+1.);
	}
	
	float d=pos.y-f;
	
	if(d>-0.1&&d<0.1){
		color=vec3(1.);
	}
	
	gl_FragColor = vec4(color, 1.0 );
}