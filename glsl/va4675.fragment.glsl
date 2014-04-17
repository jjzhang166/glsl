#ifdef GL_ES
precision mediump float;
#endif

// mod by @dist, changed coordinates to -1..1, added green stripe

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float color = 0.0;

void main( void ) {

	vec2 pos = gl_FragCoord.xy/resolution.xy * 2. - .5; // solved it by changing screen coordinates to -1..1
	vec4 color = vec4(0,0,0,1);//stander color (black)
	// we have a screen that goes from 0 to 1, but sin waves go from -1 to 1. How to solf it? change calculation to it goes from -0.5 to 0.5 by dividing the wanted Y by 2. And change the scale by +0.5
	float maxdifference = 0.05; //*abs(sin(time)*5.0); // max difference is actually just the size of the wave, oh and the commented part is to make it change size over time.
	float XThatsGonnaBeUsed = pos.x + time;//you can change this to make it scroll and such
	float TheCalculatedWantedYForSinWaves = sin(XThatsGonnaBeUsed); // pretty obivous here, to have more/less waves, change the number after pos.x
	if (abs((pos.y-0.5) - TheCalculatedWantedYForSinWaves) < maxdifference) { // Calculation!
		color += vec4(0,0,pos.x,1); // color it!
	};
	float YThatsGonnaBeUsed = pos.y + time;//you can change this to make it scroll and such
	float TheCalculatedWantedXForSinWaves = sin(YThatsGonnaBeUsed*1.01); // pretty obivous here, to have more/less waves, change the number after pos.x
	if (abs((pos.x-0.5) - TheCalculatedWantedXForSinWaves) < maxdifference) { // Calculation!
		color += vec4(0,pos.y,0,1); // color it!
	};
		
	gl_FragColor = color;

}