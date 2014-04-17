// Try to move your mouse from the far left to the far right, along the green path.

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
	    c = vec3( 0.0, sin(time*15.0)*0.25+0.75, 0.0 );  // you won
	}
	else if( status < 0.1 )
	{
	    c = vec3( 0.5, 0.0, 0.0 ); // you died
	}
	else if( p.x >= 0.96 )
	{
            float ch = 0.014;
            float a0 = mod(p.x-0.96,ch*2.)>ch ? 1.0 : 0.0;
            float a1 = mod(p.y,ch*2.)>ch ? 1.0 : 0.0;
	    if( a0 + a1 == 1.0 )
	    {
		c = vec3(1.,1.,1.);
	    }
	}
	else   // draw a path and some bad guys
	{
	    float v0 = sin( p.x*10.0+time ) * 0.3 + 0.3;
	    vec2 p1 = vec2( 0.5 + sin(time) * 0.2, 0.5 + cos(time) * 0.2 );
	    float v1 = cos(distance( p, p1 ) * 15.0+time) * 0.5 + 0.5;
	    vec2 p2 = vec2( 0.5 + sin(-time) * 0.3, 0.5 + cos(time*0.5) * 0.05 );
	    float v2 = cos(distance( p, p2 ) * 15.0+time*0.3) * 0.5 + 0.5;
	    c.b = (v0+v1+v2)/12.0;

            float path = 0.1+0.02*(1.0-p.x) - length( (p - vec2(0.55,0.55+0.1*cos(p.x*10.0+time*0.8)+0.1*sin(p.x*40.0+time*2.1)) ) * vec2(0.2,0.6+(p.x*1.5)) );
	    c.g = ( path > 0.01 ? 0.2 : 0.0 ) + clamp( path*2.0, 0.0, 0.5 );

            float d = 0.0;
            d += 0.01/length( p - vec2( 0.6 + 0.3*sin(time*0.9), 0.6 + 0.2*cos(time*1.1) ) );
	    d += 0.01/length( p - vec2( 0.5 + 0.1*sin(time*1.0), 0.5 + 0.1*cos(time*1.2) ) );
	    d += 0.01/length( p - vec2( 0.3 + 0.1*sin(time*1.4), 0.3 + 0.1*cos(time*0.7) ) );
	    d += 0.01/length( p - vec2( 0.6 + 0.3*sin(time*0.5), 0.7 + 0.3*cos(time*0.7) ) );

	    {
        	c += vec3( pow(d,1.8), 0.0, 0.0 );
	    }
	}

	vec3 mc = texture2D( backbuffer, mouse ).rgb;
	if( mouse.x <= 0.02 )
	{
	     status = 0.5; // reset
	}
	else if( ( status > 0.9 ) || ( ( status > 0.0 ) && ( mouse.x >= 0.96 ) ) )
	{
 	     status = 1.0; // won or just won
	}
	else if( ( status > 0.0 ) && ( mc.g > 0. ) && ( mc.r < 0.4 ) )
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