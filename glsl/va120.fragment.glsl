// Try to move your mouse from the far left to the far right, along the green path.

// The code is kind of a mess of if statements, and everything still looks too dull.
// Consider it a very early draft.  Definitely not as fancy as @emackey's game.

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	vec3 c = vec3( 0.0, 0.0, 0.0 );

	float status = texture2D( backbuffer, vec2( 0.0, 0.0 ) ).a;

	if( p.x < 0.02 )
	{
	    c = vec3( 0.0, 0.5, 0.0 );	// start line
	}
	else if( status > 0.9 )
	{
	    c = vec3( 0.0, 0.5, 0.0 );  // you won
	}
	else if( status < 0.1 )
	{
	    c = vec3( 0.5, 0.0, 0.0 ); // you died
	}
	else if( p.x > 0.97 )
	{
	    c = vec3( 0.0, 1.0, 0.0 );  // finish line
	}
	else   // draw a path and some bad guys
	{
            float path = 0.1+0.02*(1.0-p.x) - length( (p - vec2(0.55,0.55+0.1*cos(p.x*10.0+time*0.8)+0.1*sin(p.x*40.0+time*2.1)) ) * vec2(0.2,0.6+(p.x*1.5)) );
	    c.g = ( path > 0.01 ? 0.2 : 0.0 ) + clamp( path*2.0, 0.0, 0.5 );

            float d = 0.002/length( p - vec2( 0.6 + sin(time*0.9)*0.3, 0.6+cos(time*1.1)*0.2 ) );
	    d += 0.002/length( p - vec2( 0.5+0.1*sin(time), 0.5 + 0.1*cos(time) ) );
            if( d > 0.1 )
	    {
        	c = vec3( pow(d,0.3), 0.0, 0.0 );
	    }
	}

	vec3 mc = texture2D( backbuffer, mouse ).rgb;
	if( mouse.x <= 0.02 )
	{
	     status = 0.5; // reset
	}
	else if( ( status > 0.9 ) || ( ( status > 0.0 ) && ( mouse.x >= 0.97 ) ) )
	{
 	     status = 1.0; // won or just won
	}
	else if( ( status > 0.0 ) && ( mc.g > 0.0 ) )
	{
	     status = 0.5; // still alive
	}
	else
	{
	     status = 0.0; // dead
	}

	float alpha = 1.0;
	if( ( p.x < 0.01 ) && ( p.y < 0.01 ) )
	{
	    alpha = status; // save the status
	}

	gl_FragColor = vec4( c, alpha );
}