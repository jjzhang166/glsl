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

void main( void )
{
	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = mouse*resolution;

	float color = 0.;
	if (distance(screen_pos, mouse_pos) < 3.)
		color = nrand(screen_pos*0.01 + 0.001*time);
	else
	{
		for (float y = -6.; y <= 2.; y++)
			for (float x = -2.; x <= 2.; x++)
				color += texture2D(backbuffer, (screen_pos + vec2(x, y))/resolution + vec2(sin(x+time*4. + cos(y+time*4.)), sin(y+time))/resolution*2.).x*.57;
		color /= 25.;
		color -= 0.0003;
	}
	gl_FragColor = vec4( vec3(color), 1.0 );
}