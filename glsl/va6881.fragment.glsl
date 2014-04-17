#ifdef GL_ES
precision mediump float;
#endif

//behaves slightly differently on amd/nv

uniform float time;
uniform vec2 resolution;

vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}

void main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.xy;
	p.x += time * .045;
	p.y += time * .02;
	vec2 seed = p * 1.0;	
	
	
	seed = floor(seed * resolution * time * .1);
	
	vec3 rnd = nrand3( seed );
	gl_FragColor = vec4(pow(rnd.y,60.0), pow(rnd.y,60.0), pow(rnd.y,50.0), 1.0) * 2.0;
}
