#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float makePoint(float x,float y,float t){
	float xx=x+cos(t);
	float yy=y+sin(t);
	return 1.0/sqrt(xx*xx+yy*yy);
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy);
	//position=position*0.5;
	float y = position.x;
	float x = position.y;
	gl_FragColor.x=sin(time*0.1)*pow(0.8*(pow(sin(x+1.0),2.0)-pow(cos(y+1.0),2.0)),2.0);
	gl_FragColor.y=tan(x/2.0)*0.2;
	gl_FragColor.z=-tan(x+2.4)*0.2;
}