//@gt - decided to mess around and iterate some fake sprites...
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}



void main( void ) {
	
	vec2 pos = -resolution/2.0 +gl_FragCoord.xy;
	pos.y +=-200.;
	pos.x +=-300.;

	vec4 tx;
	float amplitude = 100.;
		
		for (int i = 0; i < 30; ++i){

		pos.y +=sin(1.0+float(i))*amplitude;
		pos.x +=fract(1.2+float(i))*amplitude;
		
			for (int i = 0; i < 12; ++i){
			tx += vec4(rect(vec2(pos.x,pos.y+float(i*20)),vec2(5.,5.),0.0001));
			}	
			

		}
	
	

	
	gl_FragColor = tx;
}