#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 // Checker fractal by uitham
 // Works kind of like perlin noise, except using a checker pattern instead of random noise,
// as in additive blending at different amplitudes at different resolutions
// this disco mode is also made by uitham
vec3 genCheck(float res)
{
	    vec3 color;
    vec2 position = vec2(gl_FragCoord.xy / resolution.xy);

	if ((mod(res*position.x, 1.) < 0.5) ^^ (mod(res*position.y, 1.) < 0.5)){
	
    
        color = vec3(0. + sin(time), 0. + cos(time), 0. + sin(time));
	}
	else{
		
        color = vec3(1. - cos(time),1. - sin(time), 1. - cos(time));
		
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
	result /= 4.;
		   

    gl_FragColor = vec4(result, 1.0);
}