#ifdef GL_ES
precision mediump float;
#endif

// Correct random walker by Optimus

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

const float inc = 0.1;

float rand(vec2 vector)
{
    return fract( 43758.5453 * sin( dot(vector, vec2(12.9898, 78.233) ) ) );
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 centered_position = position - vec2(0.5, 0.5);

	float alpha = 0.0;
	vec4 color = vec4(0.0);

	float rnd = rand(vec2(mouse.x + time, mouse.y + time));

	if (rnd < 0.25)
	{
		alpha = texture2D(backbuffer, position + disp_left).a;
	}
	else if (rnd < 0.5)
	{
		alpha = texture2D(backbuffer, position + disp_up).a;
	}
	else if (rnd < 0.75)
	{
		alpha = texture2D(backbuffer, position + disp_right).a;
	}
	else
	{
		alpha = texture2D(backbuffer, position + disp_down).a;
	}

	if (alpha != 0.0)
	{
		float r = sin(time * 16.0) + 1.0;
		float g = sin(time * time * 1.5) + 2.0;
		float b = sin(time * time * 2.5) + 4.0;
		color = vec4(texture2D(backbuffer, position).rgb, alpha) + vec4(vec3(r,g,b) * inc, alpha);
	}
	else
	{
		color = vec4(texture2D(backbuffer, position).rgb, alpha);
	}

	if (length(centered_position) < length(pixel) * radius)
	{
		vec4 sample = texture2D(backbuffer, position);
		if (sample.r == 0.0) color = vec4(1.0);
	}

	gl_FragColor = color;
}
