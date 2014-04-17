#ifdef GL_ES
precision mediump float;
#endif

//replicating something from quartzcomposer iterator/sprite in glsl. -gtoledo
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
	pos.y -=50.;
	vec4 tx;
	float amplitude = 100.*sin(time*.1)/4.+50.;
		for (int i = 0; i < 20; ++i){
		pos.y +=sin(time*.2+float(i))*amplitude;
		pos.x +=cos(time*.2+float(i))*amplitude;
		
			for (int i = 0; i < 8; ++i){
			tx += vec4(rect(vec2(pos.x+sin(float(i)*time)*64.,pos.y+cos(float(i)*time)*64.),vec2(5.,5.),0.0005));
			}		

		}
	
	

	
	gl_FragColor = tx;
}