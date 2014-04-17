// code by guanqun.lu@gmail.com

#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec4 color = vec4(0.0, 1.0, 0.0, 1.0);
	float radius = 20.0;

	vec2 pixel = gl_FragCoord.xy;
	vec2 point = floor(mouse * resolution);	

	float dist = length(pixel - point);
	float x = smoothstep(radius, radius + 1.0, dist);

	gl_FragColor = vec4( color * x);
}