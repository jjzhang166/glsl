#ifdef GL_ES
precision mediump float;
#endif

// FPS counter by Optimus
// a bar growing one pixel to the right after each frame update
// I might see in a later version if I can get starting and ending time when it reaches to the right and calculate FPS and display them with fonts. Wicked :)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 centered_coord = position - vec2(0.5);
	vec2 pixel = floor(gl_FragCoord.xy);

	float gradient;

	vec2 bar_coord = vec2(position.x - 1.0 / resolution.x, 0.0);
	vec4 sample = texture2D(backbuffer, bar_coord);
	vec4 sampleRightEdge = texture2D(backbuffer, vec2(0.99, 0.0));

	if (position.y >= 0.05)
	{
		float xpos = -0.5 + sin(centered_coord.y * 16.0 + time) * 0.06;
		float ypos = 0.0 + sin(centered_coord.x * 24.0 + 1.5 * time) * 0.04;
		const float z_fractal = 0.4;

		const float iter = 64.0;
		const float iter2 = iter / 4.0;
	
		float z0_r = 0.0;
		float z0_i = 0.0;
		float z1_r = 0.0;
		float z1_i = 0.0;
		float p_r = (centered_coord.x + xpos * z_fractal) / z_fractal;
		float p_i = (centered_coord.y + ypos * z_fractal) / z_fractal;
		float d = 0.0;
	
		float nn;
		for (float n=0.0; n<=iter; n++)
		{
			z1_r = z0_r * z0_r - z0_i * z0_i + p_r;
			z1_i = 2.0 * z0_r * z0_i + p_i;
			d = sqrt(z1_i * z1_i + z1_r * z1_r);
			z0_r = z1_r;
			z0_i = z1_i;
			if (d > iter2) break;
			nn = n;
		}
	
		gradient = (nn / iter) * 4.0;
	}
	else
	{
		if (pixel.x == 0.0)
		{
			gradient = 1.0;
		}
		else
		{
			if (sample.a == 1.0)
			{
				gradient = 1.0;
			}
			else
			{
				gradient = bar_coord.x;
			}
		}
	}

	if (sampleRightEdge.a == 1.0) gradient = 0.0;

	gl_FragColor = vec4(gradient);
}