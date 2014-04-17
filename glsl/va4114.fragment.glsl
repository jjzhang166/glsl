#ifdef GL_ES
precision highp float;
#endif

// moded by seb.cc

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float LINES = 6.0;
const float BALLS = 6.0;

//MoltenMetal by CuriousChettai@gmail.com
//Linux fix

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.yx / resolution.x * sin(time * 0.2) );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	float vertColor = 0.0;
	//*
	for(float i=0.0; i<LINES; i++){
		float t = time*(i*0.1+1.)/3.0 + (i*0.1+0.5); 
		uPos.y += sin(t+uPos.x*10.0)*0.45 ;
		uPos.x += sin(-t+uPos.y*3.0)*0.25 ;
		float value = sin(uPos.y*8.0*0.5)+sin(uPos.x*6.1-t);
		float stripColor = 1.0/sqrt(abs(value));
		vertColor += stripColor/10.0;
	}
	//*/
	float oColor=0.0;
	for (float i=0.0; i<BALLS; i++) {
		float t=time*1.3+i*2.5;
		vec2 ball=vec2(sin(t*0.3)*sin(t*0.1+1.)*sin(t*5.0+0.24),sin(t*0.11+0.04)*sin(t*0.24+0.4)*sin(t*0.18+0.4));
		float d=distance(uPos,ball);
		oColor+=0.2/d;
	}	
	
	float temp = vertColor;	
	vec3 color = vec3(temp*max(0.1,abs(sin(time*0.1))), max(0.1,(temp-oColor)*abs(sin(time*0.03+1.))), max(0.1,oColor));	
	//color *= color.r+color.g+color.b;
	gl_FragColor = vec4(color, 1.0);
}