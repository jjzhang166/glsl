#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec2 pos = gl_FragCoord.xy - resolution / 2.0;
	vec3 color = vec3(0.0);
	
	vec2 diff = pos - (mouse * resolution - resolution / 2.0);
	
	pos *= length(diff) * 0.001;
	
	if(abs(sin(pos.x * 0.2)) < 0.2 || abs(sin(pos.y * 0.2)) < 0.2)
	{
		color = vec3(0.1, 0.5, 1.0) / (length(diff) * 0.003);
	}
	
	gl_FragColor = vec4(color, 1.0);
}