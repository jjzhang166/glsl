#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backBuffer;


bool Alive(vec2 offset)
{
	return texture2D(backBuffer, (gl_FragCoord.xy + offset) / resolution).r > .99;
}


void main( void ) {
	//if (mouse.x > 0.95 || mouse.x < 0.05)
	//{
	//	gl_FragColor = vec4(0.8,0.8,0.4,1.0);
	//	return;
	//}
	vec2 pos = abs(gl_FragCoord.xy * 2. - resolution);
	float dist = distance(mouse * resolution, pos);
	if (dist < 2.)
	{
		gl_FragColor = vec4(1.);
		return;
	}

	/*dist = distance((vec2(1.)-mouse)*resolution, gl_FragCoord.xy);
	if (dist < 2.)
	{
		gl_FragColor = vec4(1.);
		return;
	}*/
	
	vec2 samples[8];
	samples[0] = vec2(-1., 1.);
	samples[1] = vec2(0, 1.);
	samples[2] = vec2(1., 1.);
	samples[3] = vec2(-1., 0);
	samples[4] = vec2(1., 0);
	samples[5] = vec2(-1., -1.);
	samples[6] = vec2(0, -1.);
	samples[7] = vec2(1., -1.);

	int count = 0;
	for (int n = 0; n != 8; ++n)
	{
		if (Alive(samples[n]))
			++count;
	}

	vec4 self = texture2D(backBuffer, gl_FragCoord.xy / resolution);

	vec3 pixel;
	if (count == 3 || (self.r > .99 && count == 2))
		pixel = vec3(.995, .7, .2);
	else
		pixel = vec3(self.r * .9, self.g * .985, self.b * 0.99);


gl_FragColor = vec4(pixel, 1.0);

/*/

float var = mod(time, resolution.x);


if (gl_FragCoord.y > resolution.y * .25)
{
	gl_FragColor = vec4(pixel, 1.0);
	return;
}
int _count = 3 - int(gl_FragCoord.x * 4. / resolution.x);
for (int n = 0; n != 4; ++n) {
	if (n==_count)
		if (distance(gl_FragCoord.xy, vec2(float(7-2*n)*0.125*resolution.x, 0.125*resolution.y)) / resolution.y > 0.1)
			gl_FragColor = vec4(vec3(mod(var,16.) / 8. > 1. ? .7 : .3), 1.);
		else
			gl_FragColor = vec4(mod(var, 4.) > 1.99 ? 1. : 0., mod(var, 8.) > 3.99 ? 1. : 0., mod(var, 2.) > 0.99 ? 1. : 0., 1.0);
	var /= 16.;
}
/**/

	// end

}

/*
vec2 noise(vec2 n) {
	vec2 ret;
	ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 33758.5453)*2.0-1.0;
	ret.y=fract(sin(dot(n.xy, vec2(34.9865, 65.946)))* 28618.3756)*2.0-1.0;
	return normalize(ret);
}*/
