//author: Hugo de Lima Gomes

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	float level = (0.5 + (sin((position.x + (time / 4.0)) * 10.0) * 0.2) * cos(time / 2.0));
	float color = 0.0;
	
	if ((position.y >= (level + 0.1)) || (position.y <= (level - 0.1)))
		color = 1.0;

	gl_FragColor = vec4(vec3(color), 1.0);
}