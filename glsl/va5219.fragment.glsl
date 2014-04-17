#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 10.0;

void main(void)
{
	vec2 c = vec2(resolution[0]/2.0, resolution[1]/2.0);
	float dist = distance(gl_FragCoord.xy, (c));
	float brightness = ((cos(dist*0.02) + 2.0) / 2.0);
	float red = 1.0 - float(smoothstep(dist, 0.0, 50.0 / abs(sin(time*0.25))));
	float green = 1.0 - float(smoothstep(dist, 0.0, 1.0 / abs(cos(time*0.05))));
	float blue = 1.0 - float(smoothstep(dist, 0.0, 50.0 / abs(tan(time*0.05))));
	
	float d = float(mod(dist + time * 100.0, 100.0) > 50.0);
	blue *= d;
	red *= d;
	green *= d;
	
	gl_FragColor = vec4(red, green, blue, 1.0);//smoothstep(0.0, dist, brightness));
}