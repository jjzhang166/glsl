// Kind of classic rastersplits.. JvB

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D tex;

void main()
{
	vec2 pxy = gl_FragCoord.xy / resolution.xy; 

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	vec3 color = vec3(0); 

	float t = mod(mod(pxy.y*10.0, 1.0)+time*5.0, 2.0);
	if (t >= 0.0 && t < 0.1) color = vec3(0.0, 0.0, 1.0);
	if (t >= 0.1 && t < 0.2) color = vec3(1.0, 0.0, 0.0);
	if (t >= 0.2 && t < 0.3) color = vec3(0.0, 1.0, 0.0);
	if (t >= 0.3 && t < 0.4) color = vec3(0.0, 1.0, 1.0);
	if (t >= 0.4 && t < 0.5) color = vec3(1.0, 1.0, 1.0);
	if (t >= 0.5 && t < 0.6) color = vec3(0.0, 1.0, 1.0);
	if (t >= 0.6 && t < 0.7) color = vec3(0.0, 1.0, 0.0);
	if (t >= 0.7 && t < 0.8) color = vec3(1.0, 0.0, 0.0);
	if (t >= 0.8 && t < 0.9) color = vec3(0.0, 0.0, 1.0);
	gl_FragColor = vec4(color, 1.0);
}
