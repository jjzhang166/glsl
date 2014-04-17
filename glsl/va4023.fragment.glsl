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
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	float alpha = 0.0;
	for(float i=-0.5; i<=0.5; i+=0.5)
	{
		const float PI = 3.14159265358979323846264;
		float angle = 1.0;//PI*sin(time)*sin(0.7*time/2.0)*sin(1.34*time/7.0)*sin(time/5.0)*sin(time/11.0);
		mat2 rotMat = mat2(cos(angle),sin(angle),-sin(angle),cos(angle));
		vec2 newPos = uPos;
		newPos.x += i;
		newPos.y += i/2.0;
		vec2 rotPos = newPos*rotMat;
		//vec2 diffPos = rot
	
		alpha += max(0.0, 1.0-(sqrt(abs(rotPos.y)))*3.0);
		alpha += max(0.0, 1.0-(sqrt(abs(rotPos.x)))*3.0);
	}
	
	/*
	float vertColor = 0.0;
	
	for(float i=0.0; i<LINES; i++){
		float t = time*(i*0.1+1.)/3.0 + (i*0.1+0.5); 
		uPos.y += sin(t+uPos.x*2.0)*0.45 ;
		uPos.x += sin(-t+uPos.y*3.0)*0.25 ;
		float value = sin(uPos.y*8.0*0.5)+sin(uPos.x*6.1-t);
		float stripColor = 1.0/sqrt(abs(value));
		vertColor += stripColor/10.0;
	}

	float oColor=0.0;
	for (float i=0.0; i<BALLS; i++) {
		float t=time*1.3+i*2.5;
		vec2 ball=vec2(sin(t*0.3)*sin(t*0.1+1.)*sin(t*0.56+0.24),sin(t*0.11+0.04)*sin(t*0.24+0.4)*sin(t*0.18+0.4));
		float d=distance(uPos,ball);
		oColor+=0.07/d;
	}	
	
	float temp = vertColor;	
	vec3 color = vec3(temp*max(0.1,abs(sin(time*0.1))), max(0.1,(temp-oColor)*abs(sin(time*0.03+1.))), max(0.1,oColor));	
*/
	
	gl_FragColor = vec4(alpha, alpha, alpha, 1.0);
}