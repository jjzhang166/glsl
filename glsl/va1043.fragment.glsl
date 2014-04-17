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
float radius = resolution.x / 10.0;

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
		alpha = pow(length(pixel) * radius - length(centered_position), 0.2);
	}
	else
	{
		float rnd = mod(sin(time * time * (position.x + position.y) * 16.0) * sin(time * time * (position.x + position.y) * 33.0), 1.0);

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

	vec3 rgb = vec3(alpha * 4.0, alpha * 1.0, alpha * 0.5);
	gl_FragColor = vec4(vec3(rgb), alpha);
}