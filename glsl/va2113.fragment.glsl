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
	vec2 c0 = ctr +  vec2( 43.0 * cos(time), 16.0 * sin(time) );
	vec2 c1 = ctr +  vec2( 50.0 * sin(time), 52.0 * cos(1.3*time) );
	//vec2 c2 = ctr +  vec2( 45.0 * sin(time), 30.0 * cos(1.6*time+sin(2.0*time)) );
	
	const float r = 30.0;
	
	vec2 d0 = c0 - pos;
	vec2 d1 = c1 - pos;
	//vec2 d2 = c2 - pos;
	
	float col = 0.0;
	col += df( d0, r );
	col += df( d1, r );
	//col += df( d2, r );
	
	float t = 0.075;
	col = smoothstep( 0.0, 1.0, (col-t)/t );
	col = pow( 2.0*col, 10.0 );
	
	gl_FragColor = vec4( vec3(col), 1.0 );

}