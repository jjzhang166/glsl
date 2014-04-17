#ifdef GL_ES
precision mediump float;
#endif

// Scripture by Optimus
// Something like a random walker but it works backwards

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 pixel = 1.0 / resolution;
float radius = 0.5;

vec2 disp_left = vec2(-pixel.x, 0.0);
vec2 disp_right = vec2(pixel.x, 0.0);
vec2 disp_up = vec2(0.0, pixel.y);
vec2 disp_down = vec2(0.0, -pixel.y);

vec4 sample = vec4(0.0);

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 centered_position = position - vec2(0.5, 0.5);

	float alpha = 0.0;

	if (length(centered_position) < length(pixel) * radius)
	{
		alpha = 1.0;
	}
	else
	{
		float rnd = mod(sin(time * time) * sin(time * time * 0.33), 1.0);

		if (rnd < 0.25)
		{
			sample = texture2D(backbuffer, position + disp_left);
		}
		else if (rnd < 0.5)
		{
			sample = texture2D(backbuffer, position + disp_up);
		}
		else if (rnd < 0.75)
		{
			sample = texture2D(backbuffer, position + disp_right);
		}
		else
		{
			sample = texture2D(backbuffer, position + disp_down);
		}

		alpha = sample.a;
	}

	vec3 rgb = vec3(alpha * 1.0, alpha * 1.0, alpha * 1.0);
	gl_FragColor = vec4(vec3(rgb), alpha);
}