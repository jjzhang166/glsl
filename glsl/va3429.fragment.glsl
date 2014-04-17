// Starfield effect, extracted from: http://glsl.heroku.com/e#883.0

#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	float scale = sin(0.7 * time) * 2.5 + 5.0;

	vec2 position = (((gl_FragCoord.xy / resolution) - 0.5) * scale) + scale * 0.75 * (mouse - 0.9);

	float gradient = 0.0;
	vec3 color = vec3(0.0);
 
	float fade = 0.0;
	float z;
 
	vec2 centered_coord = position - vec2(0.5);

	for (float i=1.0; i<=528.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 400.0, cos(i*i) * 300.0);
		float z = mod(i*i - 128.0*time, 512.0);
		star_pos += vec2(sin(time + (z * .025)), cos(time + (z * .025))) * 10.;
		float fade = (512.0 - z) / 512.0;
		vec2 blob_coord = star_pos / z;
		
		gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * (fade * fade);
	}
	color = vec3(0.2, 0.3, .5);
	color -= gradient;
//	color = vec3(gradient * 2.0, gradient, gradient / 2.0);

	gl_FragColor = vec4(color, 1.0 );
}
