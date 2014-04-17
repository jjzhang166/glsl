// Iterative fractal generator
// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;

// base pattern that generates the fractal
mat3 gen = mat3(
	-1, 1, 1,
	1, -8, -1,
	-1, 1, -1
);

// max recursion
const int max_it = 8;

// GLSL doesn't allow to index a matrix with a variable, so we have to iterate it
bool inside(vec2 p)
{
	bool val;
	for (int y = 0; y < 3; ++y)
		for (int x = 0; x < 3; ++x)
		{
			if (x == int(p.x) && y == int(p.y))
			{
				val = bool(gen[y][x]);
				break;
			}
		}
	return val;
}

float ins(vec2 p)
{
	float val=0.0;
	for (int y = 0; y < 3; ++y)
		for (int x = 0; x < 3; ++x)
		{
			if (x == int(p.x) && y == int(p.y))
			{
				val = (gen[y][x]);
				break;
			}
		}
	return val;
}



void main( void ) {

	vec2 unipos = 1.61 * ( gl_FragCoord.xy / resolution.y  - vec2(mouse.x+.5, mouse.y));


	int val = 0;
	float n = .1;
float r=0.0;
	float t = time * .5;
	for (int i = 0; i < max_it; ++i)
	{
		r = ins(mod(unipos * n, 2.));
		if (inside(mod(unipos * n, 2.)))
			val += 32;
		n += .5 * floor(fract(t*unipos.x)*31.);
		n *= floor(fract(t*unipos.y)*63.);
		
		n *= .01;
	
	}

	float sa = smoothstep(2., n, float(val == max_it));
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec4 b0;
	vec4 b1;
	vec4 b2;
	vec4 b3;
	int it = 8;
	float ry = 1./resolution.y;
	for(int i = 0; i < 32; i++){
		b0 += texture2D(backbuffer, uv+uv*vec2(0., ry));
		b1 += texture2D(backbuffer, uv-uv*vec2(0., ry));
		b2 += texture2D(backbuffer, uv+uv*vec2(ry, .0));
		b3 += texture2D(backbuffer, uv-uv*vec2(ry, .0));
		ry += ry+sa*ry;
	}
	
	vec4 bb = b0+b1+b2+b3;
	bb *= .0225;
	uv = 4.*abs(unipos);
	uv += length(unipos);
	vec4 c = (vec4(uv.x, uv.y, 2.*length(unipos), .1))+length(unipos);
	vec4 o = .1 * sa + c * .05;
	gl_FragColor = .01 + o* + bb;
}