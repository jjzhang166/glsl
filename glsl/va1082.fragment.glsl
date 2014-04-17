#ifdef GL_ES
precision mediump float;
#endif

// Burning Sun by Optimus
// I tried to do originally a random walker, I stumbled upon great diffuse effects instead

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 pixel = 1.0 / resolution;
float radius = resolution.x / 180.0;

vec2 disp_left = vec2(-pixel.x, 0.0);
vec2 disp_right = vec2(pixel.x, 0.0);
vec2 disp_up = vec2(0.0, pixel.y);
vec2 disp_down = vec2(0.0, -pixel.y);

vec4 sample = vec4(0.0);

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 centered_position = position - mouse + vec2(-0.003, 0.006);

	float alpha = 0.0;

	if (length(centered_position) < length(pixel) * radius)
	{
		alpha = pow(length(pixel) * radius - length(centered_position), 0.1);
	}
	else
	{
		float rnd = mod(sin(time * time * time * (position.x + position.y)), 1.0);
		vec2 shift = -0.001 * normalize(position - mouse);

		if (rnd < 0.25)
		{
			sample = texture2D(backbuffer, position + disp_left + shift);
		}
		else if (rnd < 0.5)
		{
			sample = texture2D(backbuffer, position + disp_up + shift);
		}
		else if (rnd < 0.75)
		{
			sample = texture2D(backbuffer, position + disp_right + shift);
		}
		else
		{
			sample = texture2D(backbuffer, position + disp_down + shift);
		}

		alpha = sample.a;
	}

	vec3 rgb = vec3(alpha * 5.0, alpha * 1.7, alpha * 0.5);
	gl_FragColor = vec4(vec3(rgb), alpha-0.0001);
}