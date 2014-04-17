#ifdef GL_ES
precision mediump float;
#endif

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
	
	vec2 c0 = ctr +  vec2( 45.0 * sin(time), 100.0 * sin(1.0*time+cos(0.0*time)) );
	vec2 c1 = ctr +  vec2( 100.0 * sin(time), 100.0 * sin(1.0*time+cos(0.0*time)) );
	vec2 c2 = ctr +  vec2( 200.0 * sin(time), 100.0 * sin(1.0*time+cos(0.0*time)) );
	vec2 c3 = ctr +  vec2( 45.0 * sin(time), 100.0 *cos(1.0*time+cos(0.0*time)) );
	vec2 c4 = ctr +  vec2( 100.0 * sin(time), 100.0 * cos(1.0*time+cos(0.0*time)) );
	vec2 c5 = ctr +  vec2( 200.0 * sin(time), 100.0 * cos(1.0*time+cos(0.0*time)) );
	
	vec2 c6 = ctr +  vec2( 45.0 * sin(time), 100.0 * sin(1.0*time+sin(0.0*time)) );
	vec2 c7 = ctr +  vec2( 100.0 * sin(time), 100.0 * sin(1.0*time+sin(0.0*time)) );
	vec2 c8 = ctr +  vec2( 200.0 * sin(time), 100.0 * sin(1.0*time+sin(0.0*time)) );
	vec2 c9 = ctr +  vec2( 45.0 * sin(time), 100.0 *cos(1.0*time+sin(0.0*time)) );
	vec2 c10 = ctr +  vec2( 100.0 * sin(time), 100.0 * cos(1.0*time+sin(0.0*time)) );
	vec2 c11 = ctr +  vec2( 200.0 * sin(time), 100.0 * cos(1.0*time+sin(0.0*time)) );
	
	vec2 c12 = ctr +  vec2( 45.0 * cos(time), 100.0 * sin(1.0*time+cos(0.0*time)) );
	vec2 c13 = ctr +  vec2( 100.0 * cos(time), 100.0 * sin(1.0*time+cos(0.0*time)) );
	vec2 c14 = ctr +  vec2( 200.0 * cos(time), 100.0 * sin(1.0*time+cos(0.0*time)) );
	vec2 c15 = ctr +  vec2( 45.0 * cos(time), 100.0 *cos(1.0*time+cos(0.0*time)) );
	vec2 c16 = ctr +  vec2( 100.0 * cos(time), 100.0 * cos(1.0*time+cos(0.0*time)) );
	vec2 c17 = ctr +  vec2( 200.0 * cos(time), 100.0 * cos(1.0*time+cos(0.0*time)) );
	
	vec2 c18 = ctr +  vec2( 45.0 * cos(time), 100.0 * sin(1.0*time+sin(0.0*time)) );
	vec2 c19 = ctr +  vec2( 100.0 * cos(time), 100.0 * sin(1.0*time+sin(0.0*time)) );
	vec2 c20 = ctr +  vec2( 200.0 * cos(time), 100.0 * sin(1.0*time+sin(0.0*time)) );
	vec2 c21 = ctr +  vec2( 45.0 * cos(time), 100.0 *cos(1.0*time+sin(0.0*time)) );
	vec2 c22 = ctr +  vec2( 100.0 * cos(time), 100.0 * cos(1.0*time+sin(0.0*time)) );
	vec2 c23 = ctr +  vec2( 200.0 * cos(time), 100.0 * cos(1.0*time+sin(0.0*time)) );
	
	vec2 c24 = ctr +  vec2( 45.0 * cos(time), 0.0 * cos(6.0*time+sin(8.0*time)) );
	vec2 c25 = ctr +  vec2( 200.0 * cos(time), 0.0 * cos(6.0*time+sin(8.0*time)) );
	vec2 c26 = ctr +  vec2( 45.0 * sin(time), 0.0 * cos(3.0*time+sin(4.0*time)) );
	vec2 c27 = ctr +  vec2( 45.0 * sin(time), 0.0 * cos(3.0*time+sin(4.0*time)) );
	vec2 c28 = ctr +  vec2( 100.0 * cos(time), 0.0 * cos(0.0*time+sin(8.0*time)) );
	vec2 c29 = ctr +  vec2( 45.0 * sin(time), 0.0 * cos(9.0*time+sin(12.0*time)) );
	
	const float r = 30.0;
	
	vec2 d0 = c0 - pos;
	vec2 d1 = c1 - pos;
	vec2 d2 = c2 - pos;
	vec2 d3 = c3 - pos;
	vec2 d4 = c4 - pos;
	vec2 d5 = c5 - pos;
	vec2 d6 = c6 - pos;
	vec2 d7 = c7 - pos;
	vec2 d8 = c8 - pos;
	vec2 d9 = c9 - pos;
	vec2 d10 = c10 - pos;
	vec2 d11 = c11 - pos;
	vec2 d12 = c12 - pos;
	vec2 d13 = c13 - pos;
	vec2 d14 = c14 - pos;
	vec2 d15 = c15 - pos;
	vec2 d16 = c16 - pos;
	vec2 d17 = c17 - pos;
	vec2 d18 = c18 - pos;
	vec2 d19 = c19 - pos;
	vec2 d20 = c20 - pos;
	vec2 d21 = c21 - pos;
	vec2 d22 = c22 - pos;
	vec2 d23 = c23 - pos;
	vec2 d24 = c24 - pos;
	vec2 d25 = c25 - pos;
	vec2 d26 = c26 - pos;
	vec2 d27 = c27 - pos;
	vec2 d28 = c28 - pos;
	vec2 d29 = c29 - pos;
	
	float col = 0.0;
	col += df( d0, r );
	col += df( d1, r );
	col += df( d2, r );
	col += df( d3, r );
	col += df( d4, r );
	col += df( d5, r );
	col += df( d6, r );
	col += df( d7, r );
	col += df( d8, r );
	col += df( d9, r );
	col += df( d10, r );
	col += df( d11, r );
	col += df( d12, r );
	col += df( d13, r );
	col += df( d14, r );
	col += df( d15, r );
	col += df( d16, r );
	col += df( d17, r );
	col += df( d18, r );
	col += df( d19, r );
	col += df( d20, r );
	col += df( d21, r );
	col += df( d22, r );
	col += df( d23, r );
	col += df( d24, r );
	col += df( d25, r );
	col += df( d26, r );
	col += df( d27, r );
	col += df( d28, r );
	col += df( d29, r );
	
	float t = 0.075;
	col = smoothstep( 0.0, 20.0, (col-t)/t );
	col = pow( 2.0*col, 4.0 );
	
	gl_FragColor = vec4( vec3(col), 1.0 );

}