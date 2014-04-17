#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 20.0;

void main(void)
{
	vec2 pos = gl_FragCoord.xy;
	//vec2 c = vec2(resolution[0]/2.0, resolution[1]/2.0);
	vec2 c = resolution / 2.0;
	float dist = distance(pos, c);
	//float brightness = ((cos(dist*0.5 - 10.0*time) + 1.0) /2.0);
	float brightness = 1.0;
	float r = ((cos(dist*.3 - 1.0*time) + 1.0) / 2.0);
	float g = ((cos(dist*.3 - 1.0*time) + 1.0) / 2.0);
	float b = ((cos(dist*.3 + 1.0*time) + 1.0) / 2.0);

	gl_FragColor = vec4(r,g,b,brightness);//smoothstep(0.0, dist, brightness));
}