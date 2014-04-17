#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 20.0;
const float PI = 3.1415;
const float TWOPI = 2.0*PI;

const float RPM = 20.0;
const float BLADES = 10.0;
const float RINGS = 5.0;

void main(void)
{
	vec2 p = gl_FragCoord.xy/resolution.xy*2.0-1.0;
	p.x/=resolution.y/resolution.x;
	float t = time * RPM/60.0;
	p *= mat2(vec2(cos(t*TWOPI),sin(t*TWOPI)),vec2(-sin(t*TWOPI),cos(t*TWOPI)));
	vec2 c = vec2(0.0);
	float dist = distance(p, c)*TWOPI*RINGS*BLADES;
	float angle = atan(p.y,p.x)/PI/2.0;
	if (p.y<0.0) angle = atan(-p.y,-p.x)/PI/2.0+0.5;

	float brightness = ((cos((dist+angle*PI*4.0*BLADES)*0.5) + 2.0) /4.0);

	gl_FragColor = vec4(brightness);//smoothstep(0.0, dist, brightness));
}