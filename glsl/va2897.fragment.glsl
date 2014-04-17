#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.14159265;
const float e = 2.71828183;

vec2 c_add(vec2 c1, vec2 c2)
{
	float a = c1.x;
	float b = c1.y;
	float c = c2.x;
	float d = c2.y;
	return vec2(a + c, b + d);
}
vec2 c_sub(vec2 c1, vec2 c2)
{
	float a = c1.x;
	float b = c1.y;
	float c = c2.x;
	float d = c2.y;
	return vec2(a - c, b - d);
}
vec2 c_mul(vec2 c1, vec2 c2)
{
	float a = c1.x;
	float b = c1.y;
	float c = c2.x;
	float d = c2.y;
	return vec2(a*c - b*d, b*c + a*d);
}
vec2 c_div(vec2 c1, vec2 c2)
{
	float a = c1.x;
	float b = c1.y;
	float c = c2.x;
	float d = c2.y;
	float real = (a*c + b*d) / (c*c + d*d);
	float imag = (b*c - a*d) / (c*c + d*d);
	return vec2(real, imag);
}
float c_abs(vec2 c)
{
	return sqrt(c.x*c.x + c.y*c.y);
}
vec2 c_pol(vec2 c)
{
	float a = c.x;
	float b = c.y;
	float z = c_abs(c);
	float f = atan(b, a);
	return vec2(z, f);
}
vec2 c_rec(vec2 c)
{
	float z = abs(c.x);
	float f = c.y;
	float a = z * cos(f);
	float b = z * sin(f);
	return vec2(a, b);
}
vec2 c_pow(vec2 base, vec2 exp)
{
	vec2 b = c_pol(base);
	float r = b.x;
	float f = b.y;
	float c = exp.x;
	float d = exp.y;
	float z = pow(r, c) * pow(e, -d * f);
	float fi = d * log(r) + c * f;
	vec2 rpol = vec2(z, fi);
	return c_rec(rpol);
}

void main( void ) {

	vec2 scale = vec2(1.5, 1.49);
	vec2 position = scale * vec2(gl_FragCoord.x / resolution.x,  gl_FragCoord.y / resolution.y) - mouse*0.5;
	
	vec2 z = position;
	const int maxIter = 32; // Maximal iterations
	vec2 power = vec2(2, 0); // Exponent. For standard Mandelbrot it is (2, 0).
	float bailout = 4.0; // Bailout
	
	int bailed = 0;
	for(int i=0; i<maxIter; i++)
	{
	    z = c_add(c_pow(z, power), position); // Recalculating z
	    if(c_abs(z) > bailout)
	    {
		    bailed = 1;
		    break;
	    }
	}
	
	if (bailed == 1)
 		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); //float4(red, green, blue, alpha)
	else
    		gl_FragColor = vec4(position.x, position.y, 0.0, 1.0);
	
}