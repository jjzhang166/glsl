#ifdef GL_ES
precision mediump float;
#endif

// 2013.03.14 by @hintz

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 p = (gl_FragCoord.xy - 0.5 * resolution) / resolution.xx;
	
	float r=0.0; 
	float a=0.0;
	float z=0.0;

	for (int i=1; i<4; i++)
	{
   	 	r += sqrt(length(p))*8.0;
	 	a += atan(p.y, p.x) * float(i);
	 	z += sin(a + sin(r-time)*3.0 - time);
		z += cos(5.0 * (a + 5.0*sin(time*0.3)));
	}
	
	gl_FragColor.rgb = vec3(cos(p*5.0-time), 0.5+0.5*cos(time))*z;
}