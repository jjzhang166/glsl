//SB: Blob variant

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
	vec2 c0 = ctr +  vec2( 143.0 * cos(time), 116.0 * sin(time) );
	vec2 c1 = ctr +  vec2( 150.0 * sin(time), 52.0 * cos(1.3*time) );
	vec2 c2 = ctr +  vec2( 145.0 * sin(time), 30.0 * cos(1.6*time+sin(2.0*time)) );
	vec2 c3 = ctr +  vec2( 105.0 * cos(time), 60.0 * sin(2.6*time+cos(3.0*time)) );
	
	const float r = 30.0;
	
	vec2 d0 = c0 - pos;
	vec2 d1 = c1 - pos;
	vec2 d2 = c2 - pos;
	vec2 d3 = c3 - pos;
	
	float col = 0.0;
	col += df( d0, r );
	col += df( d1, r );
	col += df( d2, r );
	col += df( d3, r );
	
	float t = 0.02375;
	col = smoothstep( 0.0, 1.0, (col-t)/t );
	
	float t2 = 0.02;
	float col3 =smoothstep( 0.0, 1.0, (col-t2)/t2 );
	col3 = pow( 0.30*col3, 1.0 );
	
	float col2 = pow( 2.0*col, 1.0 );
	
	gl_FragColor = vec4( vec3(col2,col,col3), 1.0 );

}