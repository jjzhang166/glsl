// Starfield effect, extracted from: http://glsl.heroku.com/e#883.0
// Colorful version

#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main(void)
{
	vec2 tex_position = (gl_FragCoord.xy / resolution.xy);
	vec4 backpixel = texture2D(backbuffer, tex_position);

	float scale = sin(0.3 * time) * 2.5 + 5.0;

	vec2 position = (((gl_FragCoord.xy / resolution) - 0.5) * scale) + scale * 0.75 * (mouse - 0.5);

	float gradient = 0.0;
	vec4 color = vec4(0.0);
 
	float fade = 0.0;
	float z;
	vec3 rgb = vec3(0.0);
 
	vec2 centered_coord = position - vec2(0.5);

	for (float i=1.0; i<=512.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 200.0, sin(i*i) * 200.0);
		float z = mod(i*i - 128.0*time, 256.0);
		float fade = (256.0 - z) / 256.0;
		vec2 blob_coord = star_pos / z;
		gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 2.5)) * (fade * fade);
		rgb.x += sin(i * 0.75) * gradient;
		rgb.y += sin(i*i * 0.4) * gradient;
		rgb.z += sin(i*i*i * 1.2) * gradient;
	}
	rgb /= 2.0;

	color = mix(vec4(rgb.x, rgb.y, rgb.z, 1.0), backpixel, 0.9);

	gl_FragColor = vec4(color);
}

