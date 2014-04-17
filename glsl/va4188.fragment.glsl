// Yet another mandelbrot, but now with zooming and colors.
// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

const float max_iter = 512.;    // lower this if it's too slow
const float color_steps = 256.;

vec3 grad(float v)
{
	vec3 c = mix(vec3(1.,0.,0.),vec3(1.,1.,0.),v);
	c = mix(c,vec3(0,0.5,1),pow(v,10.0));
        c += mix(c,vec3(1.0),pow(v,64.));
	c = mix(vec3(0),c,v);
	return c;
}

void main( void )
{
	float i;
	vec2 z;
	for (float j = 0.; j < max_iter; ++j)
	{
		z = vec2(z.x * z.x - z.y * z.y, z.x * z.y * 2.) + surfacePosition;
		if (dot(z, z) > 4.)
			break;
		++i;
	}
	if (i == max_iter)
		discard;
	float color = mod(i, color_steps) / color_steps;
	gl_FragColor = vec4(grad(color), 1.);
}