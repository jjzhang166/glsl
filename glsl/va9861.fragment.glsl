#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position =gl_FragCoord.xy / resolution.xy;
	
	float fadeValue=0.0;
	float barHeight=0.7;
	float speed=1.0;	
	float minHeight=(mod(time,speed+barHeight)/speed-(barHeight));
	float centerHeight=minHeight+ (barHeight/2.0);
	//float maxHeight=(mod(time,speed)/speed-(barHeight*0.5));
	float maxHeight=minHeight+barHeight;
	if(position.y>minHeight && position.y<maxHeight){	
		//fadeValue=sqrt( pow( minHeight-position.y,2.0));
		
		fadeValue=(barHeight/2.0)-sqrt( pow( centerHeight-position.y,2.0));
	}
		
	vec4 color=vec4(0.0,fadeValue,fadeValue,1.0);
	gl_FragColor = color;

}