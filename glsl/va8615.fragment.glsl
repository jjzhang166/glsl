#ifdef GL_ES
precision mediump float;
#endif

// This does not work in GLSL sandbox ;(
//#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define BRICKWIDTH 0.25
#define BRICKHEIGHT 0.08
#define MORTARTHICKNESS 0.01

#define BMWIDTH (BRICKWIDTH+MORTARTHICKNESS)
#define BMHEIGHT (BRICKHEIGHT+MORTARTHICKNESS)

#define MWF (MORTARTHICKNESS*0.5/BMWIDTH)
#define MHF (MORTARTHICKNESS*0.5/BMHEIGHT)

const float Ka = 1.0;
const float Kd = 1.0;
const vec3 Cbrick = vec3(0.5, 0.15, 0.14);
const vec3 Cmortar = vec3(0.5, 0.5, 0.5);

#define boxstep(a, b, x) clamp(((x)-(a))/((b)-(a)), 0.0, 1.0)

void main( void )
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / mouse.xy;
	
	float scoord = position[0];
	float tcoord = position[1];
	
	float ss = scoord / BMWIDTH;
	float tt = tcoord / BMHEIGHT;
	
	// Filter width and height
	//float swidth = fwidth(ss);
	//float twidth = fwidth(tt);
	
	if (mod(tt * 0.5, 1.0) > 0.5)
		ss += 0.5; // Shift alternate rows
	
	float sbrick = floor(ss);
	float tbrick = floor(tt);
	ss -= sbrick;
	tt -= tbrick;
	
	float w = step(MWF, ss) - step(1.0 - MWF, ss);
	float h = step(MHF, tt) - step(1.0 - MHF, tt);
	
	//float w = boxstep(MWF - swidth, MWF, ss) - boxstep(1.0 - MWF - swidth, 1.0 - MWF, ss);
	//float h = boxstep(MHF - twidth, MHF, tt) - boxstep(1.0 - MHF - twidth, 1.0 - MHF, tt);
	
	vec3 Ct = mix(Cmortar, Cbrick, w*h);

	gl_FragColor = vec4( Ct, 1.0 );

}