#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define WIDTH 6.0
#define FALLINGSPEED 11570.0
#define MinFunction

void main( void ) {
	float Factor = 30.*FALLINGSPEED;
	float CurrentCoord = floor(gl_FragCoord.x / WIDTH);
	float initialAltitude = abs(sin(mod(5.83453,cos(CurrentCoord))*23.8))*Factor;
	float timeIndex = time - (floor(time / 30.)*30.);
	float CurrentAltitude = initialAltitude - (timeIndex * FALLINGSPEED);
	float dist = abs(gl_FragCoord.y - CurrentAltitude);
	if(dist <30.) gl_FragColor = vec4(1.0);
}