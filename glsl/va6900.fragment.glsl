#ifdef GL_ES
precision mediump float;
#endif

//behaves slightly differently on amd/nv

uniform float time;
uniform vec2 resolution;

vec3 nrand3( vec2 co )
{
	return fract( sin( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) ) * 0.06;
}

void main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.xy ;
	vec2 seed = p;	
	
	seed = floor(seed * resolution);
	
	vec3 rnd = nrand3( seed * (cos(time/7.0) + sin(time/3.0)) );
	gl_FragColor = vec4(rnd.xxx, 1.0);
}
