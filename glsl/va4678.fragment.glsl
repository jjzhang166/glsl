#ifdef GL_ES
precision mediump float;
#endif

/*
I took this from
https://github.com/elemel/water-shader/blob/master/water.frag
And then modified it heavily to work here
I got rid of a few statements that didn't seem necessary
and added a ton more variables to make everything a bit clearer.

I might add some nice clouds and a sun later.

TranquilMarmot

*/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi           = 3.14159265358979323846264;
float surface_y    = 250.0; // where the waves occur on the y axis
float wave_height  = 100.0; // how high each wave is
float wave_length  = 625.0; // how long each wave is
float wave_speed   = 0.1;   // how fast the waves travel across the screen (positive for right-moving waves, negative for left)
float wave_dip     = 0.7;   // how much of a 'dip' there is between waves (0.0 for a smooth wave)
float wave_distort = 0.9;   // how much the peaks curve towards eachother
vec4  wave_color   = vec4(0.01, 0.44, 0.91, 1.0); // color of water
vec4  sky_color    = vec4(0.1,  0.2,  0.9,  1.0);    // background color

void main( void ) {
	float yThreshold = surface_y + (0.2 * wave_height);
	float wave1 = wave_dip * wave_height * abs(sin(2.0 * pi * -wave_speed * time + 2.0 * pi * gl_FragCoord.x / wave_length));
	float wave2 =  wave_distort * wave_height * pow(sin(4.0 * pi * -wave_speed * time + pi * gl_FragCoord.x / wave_length), 2.0);
	
	
	if (gl_FragCoord.y < yThreshold - (wave1 + wave2))
		gl_FragColor = wave_color;
	else
		gl_FragColor = sky_color;	
}