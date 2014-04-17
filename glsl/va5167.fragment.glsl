// This is supposed to be fire.
// made by darkstalker (@wolfiestyle)
// just a little tweak by dist

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

void main( void ) {

	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = mouse*resolution;

	float color;
	if (screen_pos.y <= 2.)
	{
		color = nrand(screen_pos*0.01 + 0.001*time);
	}
	else
	{
		color = (texture2D(backbuffer, screen_pos/resolution).x +
			1.2*texture2D(backbuffer, (screen_pos + vec2( 0,-3))/resolution).x +
			texture2D(backbuffer, (screen_pos + vec2(-2, 0))/resolution).x +
			texture2D(backbuffer, (screen_pos + vec2( 2, 0))/resolution).x)/4. - 0.0300;
	}
	gl_FragColor = vec4( color*1.01, color*1.01 - .5, 0., 1.0 );

}