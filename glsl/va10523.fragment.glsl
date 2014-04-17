#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2  resolucionEntre2 = vec2(.5,.5)*resolution.xy;
float resolucionX = 0.1*resolution.x;

void main(void){
	float x=gl_FragCoord.x;
	float y=gl_FragCoord.y;
	float angulo=atan(y/x);
	float xx = cos(angulo);
	if(angulo <(time/30.0))gl_FragColor = vec4(angulo,0,0,1);
	
	
}