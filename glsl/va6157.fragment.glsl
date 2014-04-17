#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define DOTSIZEX 3.0
#define DOTSIZEY 18.0

void main( void ) {
	//some Variables that are being initialized
	vec2 DotResolution = floor(resolution / vec2(DOTSIZEX,DOTSIZEY));
	float intensity = 0.0;
	vec2 DotCenter = floor((DotResolution - 1.0) / 2.0);
	float timeIndex = sin(time*2.);
	
	//the real stuff
	vec2 CurrentDot = floor(gl_FragCoord.xy / vec2(DOTSIZEX, DOTSIZEY));
	float CurrentX = floor(gl_FragCoord.x / DOTSIZEX - DotCenter.x);
	float CurrentY = sqrt(1000.- pow(CurrentX / 2.0, 2.0))*timeIndex + DotCenter.y;
	//if(0.25*pow(CurrentX, 2.0) > 1000.0) CurrentY = -20.0;
	
	//is our Current FragCoord on the Dot?
	if(abs(gl_FragCoord.y - (CurrentY * DOTSIZEY)) < DOTSIZEY / 2.0) 	
	{ 
		intensity = 1.0;
	}
	
	vec3 FinalColor = vec3(0.88) * intensity;
	gl_FragColor = vec4(FinalColor, 1.0);
}