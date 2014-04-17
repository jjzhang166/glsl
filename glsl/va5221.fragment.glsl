// This is supposed to be fire.
// made by darkstalker (@wolfiestyle)
// just a little tweak by dist
// Another tweak by Trisomie21 (no fire without smoke)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n) { return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void main( void ) {

	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = mouse*resolution;
	
	float d = 1.0-(gl_FragCoord.y / resolution.y);
	
	float r = nrand(screen_pos*0.01 + 0.001*time);
	
	float color;
	if (screen_pos.y <= 1.)
	{
		color = r;
	}
	else
	{
		float r2 = pow(r, 8.0);
		color = (texture2D(backbuffer, (screen_pos + vec2(0.0, -d*0.5))/resolution).x*.4 +
			 texture2D(backbuffer, (screen_pos + vec2(-r2*4.0, -d*2.0))/resolution).x*.31 +
			 texture2D(backbuffer, (screen_pos + vec2( r2*4.0, -d*r*2.0))/resolution).x*.31 ) *.99 -.008;
	}
	
	vec4 c = vec4( color*1.01, color*1.01 - .5, 0., 1.0 );
	c = mix(c, vec4(color,color,color,1), 1.0-pow(d, 16.0));
	
	gl_FragColor = c;
}