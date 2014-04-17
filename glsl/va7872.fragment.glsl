#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define THR 2.0
#define MITS 100
#define LIMIT_0 0.00000001

float calcPoint(vec2 C) {
	vec2 x=vec2(LIMIT_0,LIMIT_0);
	int ii;
	for(int i=0; i<MITS; i++) {
		
		if(length(x)<THR) {
			x = vec2(x.x*x.x-x.y*x.y, 2.0*x.x*x.y) + C;
			ii=i;
		}
	}
	if(ii<=MITS-2){
		return float(ii)/float(MITS);
	}
	else{
		return 0.0;
	}
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )-1.0;
	position.y += 0.5;
	position.x += 0.25;
	position.x = position.x*1.5;
	position = position*2.3;

	float color = calcPoint(position)*4.0;	
	float tm = sin(time/3.0);
	float cm = cos(time/3.0);
	gl_FragColor = vec4( color*vec3( tm*sin(color), cm*-cos(color), tm*-sin(color) ), 1.0 );

}