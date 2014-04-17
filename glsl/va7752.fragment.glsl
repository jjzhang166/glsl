#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159265359;

void linear(float x) 
{
	if (x <= 1.0)
		gl_FragColor = vec4(1.0-x, x, 0.0, 1.0); // red to green
	else if (x <= 2.0)
		gl_FragColor = vec4(0.0, 2.0-x, x-1.0, 1.0); // green to blue
	else
		gl_FragColor = vec4(x-2.0, 0.0, 3.0-x, 1.0); // blue to red
}

void sinus(float x)
{
	float modx = mod(x, 1.0);
	float up = sin(modx/2.0*pi); // 0.0 to 1.0
	float down = cos(modx/2.0*pi); // 1.0 to 0.0

	if (x <= 1.0)
		gl_FragColor = vec4(down, up, 0.0, 1.0); // red to green
	else if (x <= 2.0)
		gl_FragColor = vec4(0.0, down, up, 1.0); // green to blue
	else
		gl_FragColor = vec4(up, 0.0, down, 1.0); // blue to red
}

void bell(float x)
{
	float alpha = 2.0;
	float modx = mod(x, 1.0);
	float up = pow(4.0, alpha) * pow(modx/2.0, alpha-1.0) * pow(1.0-modx/2.0, alpha-1.0) / 4.0; // 0.0 to 1.0
	float down = pow(4.0, alpha) * pow((modx+1.0)/2.0, alpha-1.0) * pow(1.0-(modx+1.0)/2.0, alpha-1.0) / 4.0; // 1.0 to 0.0
	
	if (x <= 1.0)
		gl_FragColor = vec4(down, up, 0.0, 1.0); // red to green
	else if (x <= 2.0)
		gl_FragColor = vec4(0.0, down, up, 1.0); // green to blue
	else
		gl_FragColor = vec4(up, 0.0, down, 1.0); // blue to red
}

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float x = 3.0*position.x; // static 
//	float x = mod(3.0*(position.x-abs(fract(time/10.0))), 3.0); // scrolling

//	linear(x);
//	sinus(x);
	bell(x);
}