// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n)
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 grad(float v)
{
	vec3 c = mix(vec3(1.,0.,0.),vec3(1.,1.,0.),v);
	c = mix(c,vec3(0,0.5,1),pow(v,10.0));
        c += mix(c,vec3(1.0),pow(v,64.));
	c = mix(vec3(0),c,v);
	return c;
}

void main( void )
{
	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = mouse*resolution;

	float color = 0.;
	if (distance(screen_pos, mouse_pos) < 32.)
		color = nrand(screen_pos*0.01 + 0.001*time);
	else
	{
		for (float y = -3.; y <= 1.; y++)
			for (float x = -2.; x <= 2.; x++)
				color += texture2D(backbuffer, (screen_pos + vec2(x, y))/resolution).w;
		color /= 25.;
		color -= 0.0001;
	}
	gl_FragColor = vec4( grad(color*2.0), color );
}