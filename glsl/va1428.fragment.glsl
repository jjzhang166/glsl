// @ahnqqq

# ifdef GL_ES
precision mediump float;
# endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const vec3 diffuse_no  = vec3( 1.0, 0.0, 0.0 );
const vec3 diffuse_bg1 = vec3( 1.0, 1.0, 0.5 );
const vec3 diffuse_bg2 = vec3( 0.0, 0.0, 0.0 );

const float pi = 3.1415927;

vec2 rotate( vec2 p, float r )
{
	float c = cos( r );
	float s = sin( r );
	return p * mat2( c, -s, s, c );
}

bool circle( vec2 p, float r )
{
	return length( p ) < r;
}

bool inside_no( vec2 p )
{
	float l = length( p );
	if( l < .4 && abs( p.y ) < .15 )
	{
		if( p.x > 0.0 && p.x < 0.55 )
			return true;
		else if( p.x > -0.2 )
			return true;
		else if( circle( p + vec2( 0.2, 0.0 ), .15 ) )
			return true;
	}
	else if( l < .7 )
	{
		if( abs( p.y ) < .15 && abs( p.x ) < 0.55 )
			return true;
		const float r = 0.15;
		const vec2 s = vec2( 0.55, 0.0 );
		if( circle( p + s, r ) || circle( p - s, r ) || circle( p - s.yx, r ) )
			return true;
		float a = atan( p.x, p.y );
		if( l > 0.4 && ( a < 0.0 || a > pi * 0.5 ) )
			return true;
	}
	return false;
}

bool inside_bg1( vec2 p )
{
	return circle( p, 0.85 );
}

bool inside_bg2( vec2 p )
{
	return circle( p, 1.0 );
}

vec3 sprite_diffuse( vec2 p, float r )
{
	vec2 q = rotate( p, r );
	vec3 f;
	if( inside_no( q ) ) f = diffuse_no;
	else if( inside_bg1( q ) ) f = diffuse_bg1;
	else if( inside_bg2( q ) ) f = diffuse_bg2;
	else f = vec3( 0.0 );
	return f;
}

bool sprite_scissor( vec2 p )
{
	return inside_bg2( p );
}

vec3 scene( vec2 p, float t )
{
	return sprite_scissor( p )
		? sprite_diffuse( p, -t * 5.0 )
		: vec3( 1.0 );
}

void main()
{
	float t = time;
	float r = resolution.x / resolution.y;
	vec2 p = gl_FragCoord.xy / resolution * 2. - 1.;
	vec2 m = mouse * 2. - 1.;
	vec4 o = texture2D( backbuffer, gl_FragCoord.xy / resolution );
	p.x *= r;
	m.x *= r;
	p.x /= abs( cos( length( p ) * 0.25 ) );
	p.y /= abs( cos( length( p ) * 0.25 ) );
# if 1
	vec3 f;
	vec2 q = ( p - m ) * 4.0;
	if( mod( q.y, 5.0 ) > 2.5 )
	{
		q.x += t - m.y * 5.0;
		q = mod( q, 2.5 ) - 1.25;
		f = scene( q * 1.2, t );
	}
	else
	{
		q.x += t * 3.0 + m.y * 5.0;
		q = mod( q, 2.5 ) - 1.25;
		f = scene( q, t );
	}
	
	float l = ( 1.0 - length( p * 0.25 ) );
	o = mix( vec4( f, 1.0 ), o, 0.85 );
	o.rg += mod( gl_FragCoord.x, 2.0 ) * 0.1 * l;
	o.b += mod( gl_FragCoord.y, 2.0 ) * 0.1 * l;
	o *= vec4( 1.0, 0.9, 0.8, 1.0 ) * l;
	gl_FragColor = o;
# else
	gl_FragColor = vec4( scene( p * 1.1, t ), 1.0 );
# endif
}

