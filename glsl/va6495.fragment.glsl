#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;


vec3 nrand3( vec2 co )
{
	float x = sin( (co.x+co.y*8.3e-2)*9.7e2 );
	return fract( x*vec3(1.9e3, 2.9e3, 4.3e3) );
}

void main(void)
{
	float ofs = fract(time);
	vec2 p = gl_FragCoord.xy / resolution.xy;
	vec2 seed = p;
	seed += (p.y>0.5) ? vec2( 0.0, ofs ) : vec2(0.0);
	vec3 rnd = nrand3( seed );
	gl_FragColor = vec4(rnd, 1.0);
}
