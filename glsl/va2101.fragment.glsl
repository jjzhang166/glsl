#ifdef GL_ES
precision mediump float;
#endif

// metablobgalaxthing

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float df( vec2 v, float r )
{
	float d = length(v);
	return 1.0 / d;
}

void main( void )
{
	vec2 pos = ( gl_FragCoord.xy );

	
	vec2 ctr = resolution.xy / 2.0;
	vec2 c0 = ctr +  vec2( 43.0 * cos(time), 16.0 * sin(time) );
	vec2 c1 = ctr +  vec2( 50.0 * sin(time), 52.0 * cos(1.3*time) );
	vec2 c2 = ctr +  vec2( 45.0 * sin(time), 30.0 * cos(1.6*time+sin(2.0*time)) );
	
	vec2 c[100];
	vec2 d[100];
	const float r = 30.0;
	float col = 0.0;
	
	for (float x = 0.0; x < 10.0; x++)
	for (float y = 0.0; y < 10.0; y++)
	{
	 c[int(x + x*y)] = ctr + 0.259*vec2( (25.0 + (x + x*y)/1.0) * cos(time + x + x*y)*7.0, (10.0 + (x + x*y)/1.0)*sin(time + x + x*y)*7.0);
	 d[int(x + x*y)] = c[int(x + x*y)] - pos;
	 col += df( d[int(x + x*y)], r);
	}
	
	
	
	
	//vec2 d0 = c0 - pos;
	//vec2 d1 = c1 - pos;
	//vec2 d2 = c2 - pos;
	
	
	//col += df( d0, r );
	//col += df( d1, r );
	//col += df( d2, r );
	
	float t = 1.1953075;
	col = smoothstep( 0.0, 1.0, (col-t)/t );
	col = pow( 2.0*col, 10.0 );
	
	gl_FragColor = vec4( vec3(col), 1.0 );

}