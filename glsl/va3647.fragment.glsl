#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 20.0;

void main(void)
{
	vec2 c = vec2(resolution[0]/2.0, resolution[1]/2.0);
	float dist = distance(gl_FragCoord.xy, (c));
	float brightness = ((cos(dist*0.5 + 100.0*time) + 2.0) /4.0);

	gl_FragColor = vec4(brightness);//smoothstep(0.0, dist, brightness));
}