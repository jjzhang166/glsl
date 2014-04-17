// resatiate.com
// based on http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
#define N 50
#define pi 3.1415926535
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

// thanks http://glsl.heroku.com/e#5654.6
float cabs (const vec2 c) { return dot(c,c); }
vec2 cconj(const vec2 c) { return vec2(c.x, -c.y); }
vec2 cmul(const vec2 c1, const vec2 c2)
{
	return vec2(
		c1.x * c2.x - c1.y * c2.y,
		c1.x * c2.y + c1.y * c2.x
	);
}
vec2 cdiv(const vec2 c1, const vec2 c2)
{
	return cmul(c1, cconj(c2)) / dot(c2, c2);
}
vec3 Hue(float H)
{
	H *= 6.;
	return clamp(vec3(
		abs(H - 3.) - 1.,
		2. - abs(H - 2.),
		2. - abs(H - 4.)
	), 0., 1.);
}
vec3 HSVtoRGB(float h, float s, float v)
{
    return ((Hue(h) - 1.) * s + 1.) * v;
}
//
float wave(float t) { return .5 - .5 * cos(t); }

float fractal(vec2 z, vec2 c, float m, float color)
{		
	vec2 co = c;
	vec2 zo = z;
	vec2 zc = z / c;
	for ( int i = 0; i < N; i++ ){
		m = cabs(z);
		
		z = abs(z)/m + c;
		
		zo.x = (z.x * z.y * 5.) / zc.x;
		zo.y = exp(z.y * m) + c.y;
		
		float xtemp = (z.x * z.x) - (z.y * z.y) + c.x;
		z.y = (2.0 * z.x * z.y) + c.y;
		z.x = xtemp;
				
		color += exp(-cabs(z /cdiv(c, z)));
		color -= exp(-10.974/cabs(zo / z));
		
	}
	
	//c = pi * vec2(wave((time * .00021)/4.5), wave((time * .00061)/12.42));
	//c = vec2(0.15, 0.05);
	//c += mouse;
	
	for ( int i = 0; i < N; i++ ){
		float xtemp = (z.x * z.x) - (z.y * z.y) + c.x;
		z.y = (2.0 * z.x * z.y) + c.y;
		z.x = xtemp;
		
		if (((z.x * z.x) + (z.y * z.y)) > 2.)
		{
			color -= exp(min(cabs(zc), pow(float(i), m))); 			
			break;
		}
		else
		{
			zc = abs(z) / m + tan(c) / m;
			color += exp(mod(float(i), m)/12.9987002);
		}
	}
	
	color /= 10.30;
	
	return color;
}

// fun with cartesian to polar to cartesian again and a little caleidoscopic effect
void main( void ) {
	float pi2 = pi * 2.0;
	
	vec2 z = surfacePosition*2.4;
	float r = atan(z.x, z.y);
	float a = length(z);
	r = (r * 3.0)+time;
	a = 1.01/sin(a+(time*0.5));
	z = vec2( a * cos(r), a * sin(r));
	vec2 c = vec2( 0.000345+(cos((a/r)+(time*0.1))*0.2), 0.06+(sin((a/r)+(time*0.11))*0.2) );
	//c += -1.0235 * vec2(wave((time * .0021)/2.5), wave((time * .0061)/1.42));
	//c = mouse;
	float color = .910;			

	color = fractal(z, c, 6., color);
	
	gl_FragColor = vec4(HSVtoRGB(
		wave(color + 27.0012),
		wave(color * 19.31),
		wave(color * 15.23)
	), 1.0);	
}