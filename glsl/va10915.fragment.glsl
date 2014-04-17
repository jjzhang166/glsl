// GLSL - Pong
//
// by Christoph Brzozowski 2013

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 center;
vec3 state;
vec2 dir;
vec2 bat;

#define ball_size 2.0
#define bat_size 16.0
void main( void )
{

	state  = texture2D( backbuffer, vec2( 2.5, resolution.y - 0.5 ) / resolution ).rgb;
	dir    = texture2D( backbuffer, vec2( 4.5, resolution.y - 0.5 ) / resolution ).rg * vec2( 2.0, 2.0 ) - vec2( 1.0, 1.0 );
	center = texture2D( backbuffer, vec2( 0.5, resolution.y - 0.5 ) / resolution ).rg * 255.0;

	bat = vec2( mouse.x * resolution.x, 10.0 );	
	
	if( bat.x + bat_size > 200.0 )
	    bat.x = 200.0 - bat_size;
	if( bat.x - bat_size < ball_size )
	    bat.x = bat_size + ball_size;
	
	if( state.r < 0.5 )
	{
		center = vec2( bat.x, bat.y + ball_size * 2.0 );
		dir = vec2( 1.0, 1.0 );
		state.r = 1.0;
	}
	
	if( center.x >= 200.0 || center.x <= ball_size )
	    dir.x = -dir.x;
	if( center.y >= 200.0 )
	    dir.y = -dir.y;
	if( center.y <= 1.0 )
	    state.r = 0.0;
		
	if( center.x >=	bat.x - bat_size && center.x <= bat.x + bat_size && center.y < bat.y + ball_size * 2.0 )	
	{
	    dir.y = -dir.y;
	    if( center.x > bat.x )
	    	dir.x = 1.0;
	    else
		dir.x = -1.0;
	}
	
	vec2 diff  = ( gl_FragCoord.xy - center );	
	vec2 diff2 = ( gl_FragCoord.xy - bat );  
		
	if( abs( diff.x ) < ball_size && abs( diff.y ) < ball_size )		
		gl_FragColor = vec4( 0.0, 1.0, 0.0, 1.0 );
	
	if( abs( diff2.x ) < bat_size && abs( diff2.y ) < ball_size )		
		gl_FragColor = vec4( 1.0 );
		   
	if( int(gl_FragCoord.x) == 0 && int(gl_FragCoord.y) == int( resolution.y ) - 1 )
	{
		center += dir;
		//center = vec2( 100, 50 );
		gl_FragColor.rg = center / 255.0;
	}
	if( int(gl_FragCoord.x) == 2 && int(gl_FragCoord.y)  == int( resolution.y ) - 1 )
	{		
		gl_FragColor.r = state.r;
	}			
	if( int(gl_FragCoord.x) == 4 && int(gl_FragCoord.y)  == int( resolution.y ) - 1 )
	{		
		gl_FragColor.rg = ( dir + vec2( 1.0, 1.0 ) ) * vec2( 0.5, 0.5 );
	}	
	if( gl_FragCoord.y < 200.0 )
	{
		if( ( gl_FragCoord.x < ball_size || abs( gl_FragCoord.x - 200.0 - ball_size ) < ball_size ) )
			gl_FragColor.b = 1.0;
	}
	if( gl_FragCoord.x < 200.0 + ball_size * 2.0 )
		if( abs( gl_FragCoord.y - 200.0 - ball_size ) < ball_size )
			gl_FragColor.b = 1.0;
	if( gl_FragCoord.y < resolution.y - 5.0 )
		gl_FragColor = mix( gl_FragColor, texture2D( backbuffer, gl_FragCoord.xy / resolution ), 0.65 ); 
	
}