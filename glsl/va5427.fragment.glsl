#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415
#define DR 0.012

vec4 one(float x, float y)
{
	float realX = (x - 0.5);
	float realY = (y - 0.5);
	
	float red = 0.2 + realX * 0.7 * sin(time * 4.0);
	float green = realY * 0.7 * cos(time * 4.0);
	float blue = acos(time * 30.);
	return vec4(red, green, blue, 1.0);
}

vec4 two(float x, float y)
{
	float realX = (x - 0.5) + sin(time) * 0.3;
	float realY = (y - 0.5) + cos(time * 1.3 + 0.3) * 0.2;
	float result = mod(floor(sqrt(realX * realX + realY * realY) / DR) - time * 31.0,  69.0);
        return vec4(mod(1.0 - result * 0.12 * sin(time), 1.0), (mod(result * 0.017 * cos(time), 1.0)), sin(result* time * 0.0043), 1.0);
}

vec4 three(float x, float y)
{
	float realX = (x - 0.5) + sin(time) * 0.3;
	float realY = (y - 0.5) + cos(time * 1.3 + 0.3) * 0.2;
	float result = mod(floor((abs(realX) + abs(realY)) * 115.0) + time, 31.0);
        return vec4(mod(1.0 - result * 0.12 * sin(time), 1.0), (mod(result * 0.017 * cos(time), 1.0)), sin(result * time * 0.0043), 1.0);
}

vec4 four(float x, float y)
{
	float result = mod(floor(sqrt(y * y + x * x) / DR) - time * 1.0, 20.0);
	
	float red = mod(1.0 - result * 0.1 * sin(time), 1.0);
	float green = mod(result * 0.1 * cos(time), 1.0);
	float blue = sin(result * time * 0.005);
	
	return vec4(red, green, blue, 1.0);
}

vec4 five(float x, float y)
{
	float result =  mod(floor((abs(x) + abs(y)) / DR) + time, 15.0);
	
	float red = mod(1.0 - result * 0.1 * sin(time), 1.0);
	float green = mod(result * 0.1 * cos(time), 1.0);
	float blue = sin(result * time * 0.005);
	return vec4(red, green, blue, 1.0);
}

vec4 six(float x, float y)
{
	float realX = x - 0.5;
	float realY = y - 0.5;
	
	float c = 20.0;
	
	float angle = 2.0 * time;
	
	float sa = sin(angle);
	float ca = cos(angle);

	float nx = realX * ca - realY * sa;
	float ny = realY * ca + realX * sa;
	
	realX = nx;
	realY = ny;
	
	float red = sin(time)* mix(0.2, 1.0, sin(time) * 5.0 * distance(vec2(realX, realY), vec2(0.0, 0.0)));
	float green = cos(time)* mix(0.2, 1.0, sin(time) * 5.0 * distance(vec2(realX, realY), vec2(0.0, 0.0)));
	float blue = tan(time)* mix(0.2, 1.0, sin(time) * 5.0 * distance(vec2(realX, realY), vec2(0.0, 0.0)));
	
	float coeff = 20. + sin(time*5.) * 10.;
	if((sin((realX  + sin(time))*6.*PI)) - mod(realY * coeff, sin(time)*3.) < 0.000005) {
		red = 1. - red;
		green = 1. - green;
		blue = 1. - blue;
	}
	
	return vec4(red, green, blue, 1.0);
}

vec4 seven(float x, float y) 
{
	float red;
	float green;
	float blue;
	
	float rx = x - 0.5;
	float ry = y - 0.5 + 0.35*sin(rx*10. + mod(-4.5*time, 2.*PI));
	
	rx += sin(time) * 3.;
	ry += cos(time) * 0.2;
	
	red = sin(ry*30.*mix(1., 1.5, sin(time*1.2) + cos(time*1.4) + 0.5)) < 0. ? 1. : cos(time) + 0.2;
	green = sin(ry*30.*mix(1., 1.5, sin(time*1.2) + cos(time*1.4) + 0.5)) < 0. ?  1. - sin(time) : sin(time);
	blue = sin(fract(time) * 2. * sin(time));
	
	return vec4(red, green, blue, 1.0);
}

void main( void )
{
        float x = gl_FragCoord.x / resolution.x;
        float y = gl_FragCoord.y / resolution.y;
	
	//gl_FragColor = seven(x, y);
	
	float index = mod(time, 35.0);
	float result;
	if(index < 5.0)
	{
		gl_FragColor = one(x, y);
	}
	else if(index < 10.0)
	{
		gl_FragColor = two(x, y);
	}
	else if(index < 15.0)
	{
		gl_FragColor = three(x, y);
	}
	else if(index < 20.0)
	{
		gl_FragColor = four(x, y);
	}
	else if(index < 25.0)
	{
		gl_FragColor = five(x, y);
	}
	else if(index < 30.)
	{
		gl_FragColor = six(x, y);
	}
	else //if(index < 35.)
	{
		gl_FragColor = seven(x, y);
	}
}