precision highp float;
#define MAX_ITER 80

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
void main()
{
	//Modified by @hektor41 05/10/12

	int x2;
	vec2 z = vec2(0);
	vec2 temp;
	vec2 p=gl_FragCoord.xy;
	p/=resolution;
	
	/*
	normalize at 
		x_mod = 2.0
		x_mod_spd = 800.0
		y_mod = 2.0
		y_mod_spd  = 800.0
	*/
	float x_mod = 2.0;
	float x_mod_spd = 800.0;
	float y_mod = 20.0;
	float y_mod_spd = 2.0;
	
	for(int x=0;x<MAX_ITER;x++) {
		x2=x;
		if(length(z.xy) > 10.) break;
		temp.x = pow(z.x, abs(sin(time/x_mod_spd)*x_mod) ) - pow(z.y,abs( sin(time/y_mod_spd)*y_mod)) + p.x*5.0 - 2.5;
		temp.y = 2.0*z.x*z.y + p.y*3.0 - 1.5;
		z = temp;
	}
	gl_FragColor = vec4(vec3(sqrt(float(x2)/float(MAX_ITER))),1.9);
}