#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
varying vec2 surfacePosition;
uniform vec2 resolution;
const float iterations = 20.0;
 //Checker fractal by uitham
 //Works kind of like perlin noise, except using a checker pattern instead of random noise,
// as in additive blending at different amplitudes at different resolutions


//Now with twice as much iterations, and you can pan and zoom with the left and right mouse buttons.
vec3 genCheck(float res)
{
	vec3 color;
	vec2 position = vec2(gl_FragCoord.xy / resolution.xy);
	color = (mod(res * surfacePosition.x, 1.) < 0.5 ^^ mod(res * surfacePosition.y, 1.) < 0.5) ?
		vec3(0, 0, 0) : vec3(1, 1, 1);
	return color;
}

void main()
{
	float diExp = 1.;
	vec3 result = genCheck(1.0);
	for(float i = 0.7; i <= iterations; i++)
	{
		
		result += genCheck(diExp) / i;
		diExp *= 2.0;
	}
	result /= iterations / 4.;
    	gl_FragColor = vec4(result, 1.0);
}