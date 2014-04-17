/*
 * kaliset (http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/)
 * by Piers Haken.
 * 


vec2 cmul(const vec2 c1, const vec2 c2)
{
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

float wave(float t) { return .5 - .5 * cos (t); }

vec2 one2 = vec2(1.,0.);

vec2 circle (float a) { return vec2 (cos(a), sin(a)); }

mat2 rotate(float a)
{
	return mat2(cos(a), -sin(a), sin(a), cos(a));
}

vec2 liss (float fx, float fy)
{
	return vec2 (sin (time * fx), cos (time * fy));
}

void main( void )
{
	#if 1
	vec2 c = (mouse * 2. - 1.) * 1.5 - .25;
	c.x = -0.32+0.01*sin(time);
	c.y = -0.14;
	#else
	vec2 c = .8 * vec2(wave(time/23.2347890), wave(time/37.871923));
	c = circle(time / PI) * .8 + circle(time) * .2;
	#endif
	
	vec2 z = surfacePosition*0.4+vec2(0,1.0);
	
	#if 0
	c = z;
	z = vec2(0,0);
	#endif
	
	vec2 R =vec2(0.97,0);// circle (time / 5.123);
	
	float color = 0.;
	float m = 0.;
	for (int i = 0; i < max_iteration; ++i)
	{
		vec2 zold = z;
		
		float m = cabs(z);
		//z = abs(cmul(z, cmul(z,R)))/(m*m) + c;
		z = abs(cmul(z, R))/m + c;
		
		color += exp(-cabs(z));
		color -= exp(-1./cabs(zold - z));
	}
	
	color /= float(max_iteration);
	color=pow(sin(pow(color+0.9,8.)-time),10.5);

	gl_FragColor = vec4(color,color,color,1.0)
	;
	
}