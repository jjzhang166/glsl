#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// https://www.shadertoy.com/view/4dlGW2

// Tileable noise, for creating useful textures. By David Hoskins, Sept. 2013.
// It can be extrapolated to other types of randomized texture.

//#define SHOW_TILING


//----------------------------------------------------------------------------------------
float Hash(in vec2 p, in float scale)
{
	p = mod(p, scale);
	return fract(sin(dot(p, vec2(13.6898, 16.3563))) * 353753.373453);
}

//----------------------------------------------------------------------------------------
float Noise(in vec2 x, in float scale )
{
	x *= scale;

	// Half baked time movement, just for show...
	x += vec2(sin(time * .3-scale), cos(time * .2+scale))*5.0/sqrt(scale);

	vec2 p = floor(x);
	vec2 f = fract(x);
	//f = f*f*(3.0-2.0*f);
	f = (1.0-cos(f*3.1415927)) * .5;
	float res = mix(mix(Hash(p,  	scale),
					Hash(p + vec2(1.0, 0.0), scale), f.x),
				    mix(Hash(p + vec2(0.0, 1.0), scale),
					Hash(p + vec2(1.0, 1.0), scale), f.x), f.y);
    return res;
}

//----------------------------------------------------------------------------------------
float fBm(in vec2 p)
{
	float f = 0.4;
	// Change starting scale to any integer...
	float scale = 7.0;
	float amp = 0.55;
	
	for (int i = 0; i < 8; i++)
	{
		f += Noise(p, scale) * amp;
		amp *= -.59;
		// Scale must be incremented by 2x...
		scale *= 2.0;
	}
	return f;
}

//----------------------------------------------------------------------------------------
void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	#ifdef SHOW_TILING
	uv *= 2.0;
	#endif
	
	
	float bri = fBm(uv);
	
	bri = min(bri * bri, 1.0); // ...cranked up the contrast for no reason.
	
	gl_FragColor = vec4(vec3(bri),1.0);
}