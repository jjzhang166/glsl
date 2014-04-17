#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//Matrix

// Armageddon!

vec2 pixel = 2.0 / resolution;
vec2 disp_left = vec2(-pixel.x, 0.0);
vec2 disp_right = vec2(pixel.x, 0.0);
vec2 disp_up = vec2(0.0, pixel.y);
vec2 disp_down = vec2(0.0, -pixel.y);


void main( void ) {
	
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec4 color = vec4(1.0);
	
	color.x = (resolution.y - gl_FragCoord.y) * pixel.y * 0.1;
	color.y = -mod(gl_FragCoord.y + time , cos(gl_FragCoord.x) + 0.004)*.5;
	color.z = gl_FragCoord.y * pixel.y * 0.1;
	
	
	
	float rnd = mod(sin(time * time * (position.x + position.y)) * sin(time * time * time * (position.x + position.y)), 1.0);
	vec4 sample;

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
	
	color.x += (sample.y + sample.x) / 2.0;
	
	gl_FragColor = color;
}