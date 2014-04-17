#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 //Checker fractal by uitham
 //Works kind of like perlin noise, except using a checker pattern instead of random noise,
// as in additive blending at different amplitudes at different resolutions
// Here is another kind of way of doing it, except with the board being divided by vertical stripes instead of blocks.
// To compensate for the boringness, I made it wavey.
// You guessed it right, also made by uitham
vec3 genCheck(float res)
{
	    vec3 color;
    vec2 position = vec2(gl_FragCoord.xy / resolution.xy);

	if ((mod(res*position.x/sin(position.y + time / 10.) , 1.) < 0.5) ){
	
    
        color = vec3(0, 0, 0);
	}
	else{
		
        color = vec3(1,1, 1);
		
	}
	return color;
}

void main()
{
vec3 result = genCheck(1.) / 1.;
	result += genCheck(2.) / 2.;
	result += genCheck(4.) / 3.;
	result += genCheck(8.) / 4.;
	result += genCheck(16.) / 5.;
	result += genCheck(32.) / 6.;
	result += genCheck(64.) / 7.;
	result += genCheck(128.) / 8.;
	result += genCheck(256.) / 9.;
	result += genCheck(512.) / 10.;
	result += genCheck(1024.) / 11.;
	result /= 3.;
		   

    gl_FragColor = vec4(result, 1.0);
}