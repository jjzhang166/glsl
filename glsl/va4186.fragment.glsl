// This now _really_ looks like fire.
// made by darkstalker (@wolfiestyle)
// just a little tweak by dist and $author again

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

void main( void ) {

	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = mouse*resolution;

	float color;
	if (screen_pos.y <= 1.)
	{
		color = nrand(screen_pos*0.01 + 0.001*time);
	}
	else
	{
		color = (texture2D(backbuffer, screen_pos/resolution).a +
			1.2*texture2D(backbuffer, (screen_pos + vec2( 0,-5))/resolution).a +
			texture2D(backbuffer, (screen_pos + vec2(-1, 0))/resolution).a +
			texture2D(backbuffer, (screen_pos + vec2( 1, 0))/resolution).a)/4. - 0.031;
	}
	// 4th component seems to do nothing, let's use it for feedback
	gl_FragColor = vec4( grad(color), color*1.01 );

}