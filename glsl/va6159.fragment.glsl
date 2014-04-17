#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define DOTSIZEX 3.0
#define DOTSIZEY 3.0

void main( void ) {
	//some Variables that are being initialized
	vec2 DotResolution = floor(resolution / vec2(DOTSIZEX,DOTSIZEY));
	float intensity = 0.0;
	vec2 Center = floor((DotResolution - 1.0) / 2.0);
	float timeIndex = mod(time, 1.0);
	if( timeIndex < 0.1)timeIndex = 0.1;
	
	//the real stuff
	vec2 CurrentDot = floor(gl_FragCoord.xy / vec2(DOTSIZEX, DOTSIZEY));
	float CurrentX = floor(gl_FragCoord.x / DOTSIZEX + Center.x);
	float CurrentY = sin(CurrentX / 4.0)*10.0+Center.y;
	
	//is our Current FragCoord on the Dot?
	if(abs(gl_FragCoord.y - (floor(CurrentY) * DOTSIZEY)) < 4.0) 	
	{
		intensity = 2.0;
	}
	
	vec3 FinalColor = vec3(0.88) * intensity;
	gl_FragColor = vec4(FinalColor, 1.0);
}