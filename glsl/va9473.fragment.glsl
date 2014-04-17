#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash(float x)
{
	return fract(sin(x) * 43758.5453);
}

vec4 tv(vec4 col, vec2 pos)
{	
	float speed = 0.0;
	
	vec4 tmp;
	
	// vibrating rgb-separated scanlines
	tmp.r = sin(( pos.y + 0.002 + sin(time * 64.0) * 0.0002 ) * resolution.y * 2.0 + time * speed);
	tmp.g = sin(( pos.y + 0.004 - sin(time * 70.0) * 0.0002 ) * resolution.y * 2.0 + time * speed);
	tmp.b = sin(( pos.y + 0.006 + sin(time * 90.0) * 0.0002 ) * resolution.y * 2.0 + time * speed);

	// normalize tmp
	tmp = clamp(tmp, 0.0, 1.0);
	
	// accumulate
	col *= tmp;
	
	// grain
	float grain = hash( ( pos.x + hash(pos.y) ) * time ) * 0.15;
	col += grain;
	
	// flicker
	float flicker = ( sin(hash(time)) + 0.5 ) * 0.075;
	col += flicker;
	
	// vignette
	vec2 t = 2.0 * ( pos - vec2( 0.5 ) );
	
	t *= t;
	
	float d = 1.0 - clamp( length( t ), 0.0, 1.0 );
	
	col *= d;
	
	return col;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	vec4 col = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	
	col = tv(col, position);
	
	gl_FragColor = col;
}