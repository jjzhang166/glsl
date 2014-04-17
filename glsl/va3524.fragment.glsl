#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 25.0;

void main(void)
{
	float dist	 = distance(gl_FragCoord.xy, (mouse * resolution));
	float brightness = (threshold * ((cos(time * 2.0) + 3.0) / 4.0));
	float value	 = smoothstep(0.0, dist, brightness);
	vec4  color	 = vec4(vec3(value), 1.0);
	
	color.r *= ((-cos((time / 4.0) * 1.5) / 2.0) + 0.5);
	color.g *= ((cos(((time / 4.0) + 2.0) * 2.0) / 2.0) + 0.5);
	color.b *= ((cos((time / 4.0) * 3.0) / 2.0) + 0.5);

	gl_FragColor = color;
}