// @dekdev
#ifdef GL_ES
precision mediump float;
#endif

#define PIECES 5.0 
#define DIAMETER 200.0
#define THIKNESS 2.0
#define SPEED 3.0

uniform float time;
uniform vec2 resolution;

float circle(vec2 p){

	float l = length(p);
	
	if (l < DIAMETER && l > DIAMETER-THIKNESS && sin(time*SPEED+PIECES*atan(p.y, p.x)) < 0.0) return 1.0;
	
	return 0.0;	
}

void main( void ) {
	
	vec2 pos = -resolution/2.0 +gl_FragCoord.xy;
	vec4 finalColor;
	
	for (int i = -10; i < 10; i++)
	{
		finalColor += vec4(circle(pos+float(i)*10.0));
	}
	
	gl_FragColor = finalColor;
}