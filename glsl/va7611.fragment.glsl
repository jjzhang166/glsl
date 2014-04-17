#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// 2013-03-17 by @hintz

void main(void)
{
	vec2 p = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.yy;
	
	float r = length(p);
	float a = atan(p.y+0.25*sin(time*0.54), p.x+0.25*cos(time*0.91));
	float a2 = atan(p.y+0.25*sin(time*0.55), p.x+0.25*cos(time*0.9));
	float z = cos(3.0 * (a + r*3.0*cos(time*0.81) - sin(time*0.99)));
	float z2 = cos(4.0 * (a2 + r*2.0*cos(time*1.1) - sin(time*1.01)));
	
	vec3 col = r*vec3((z*z2+r)*2.0, 1.0-sin(time+2.0*(r*z-z2)), (z2-z*r)*2.0) ;
	
	gl_FragColor.rgb = 1.0 - cos(col);
}

