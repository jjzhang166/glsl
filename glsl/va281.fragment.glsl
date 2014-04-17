#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float box( vec2 p, vec4 rect )
{
    float trim = min(rect.z, rect.w) * 0.5;
    float minX = min(p.x - rect.x, rect.x + rect.z - p.x);
    float minY = min(p.y - rect.y, rect.y + rect.w - p.y);
    return ((minX > 0.0) && (minY > 0.0) && ((minX + minY) > trim)) ? 1.0 : 0.0;
}

float digit( vec2 p, vec4 dim, float d)
{
	d = (d - mod(d,1.0)) / 10.0;
	d = mod( d, 1.0 );

	p.xy -= dim.xy;
	p.xy /= dim.zw;
	

	float c = 0.0;
	
	// I'm sure all of these can be improved... in fact, this way may actually be slower than just if else if else if else for
	// all ten numbers.  Oh well, it was worth a shot :)

	// top - 0, 2, 3, 5, 7, 8, 9
	c += box( p, vec4( 0.05, 0.9, 0.9, 0.1 ) ) * ( cos( (0.85*d+0.1)*30.0) - sin(pow(d,1.0)) < 0.0 ? 1.0 : 0.0 );

	// middle - 2, 3, 4, 5, 6, 8, 9
	c += box( p, vec4( 0.05, 0.45, 0.9, 0.1 ) ) * ( min( pow(6.0*d,2.0), pow(20.0*(d-0.7),2.0) ) < 1.0 ? 0.0 : 1.0 );

	// bottom - 0, 2, 3, 5, 6, 8
	c += box( p, vec4( 0.05, 0.0, 0.9, 0.1 ) ) * ( max( cos(18.6*pow(d,0.75)), 1.0-pow(40.0*(d-0.8),2.0)) > 0.0 ? 1.0 : 0.0 );

	// bottom left - 0, 2, 6, 8
	c += box( p, vec4( 0.0, 0.08, 0.1, 0.39 ) ) * ( cos( d * 30.0 ) * abs(d-0.4) > 0.1 ? 1.0 : 0.0 );
	
	// bottom right - 0, 1, 3, 4, 5, 6, 7, 8, 9
	c += box( p, vec4( 0.9, 0.08, 0.1, 0.39) ) * ( pow( 4.0*d-0.8, 2.0) > 0.1 ? 1.0 : 0.0 );

	// top left - 0, 4, 5, 6, 8, 9
	c += box( p, vec4( 0.0, 0.52, 0.1, 0.39 ) ) * ( sin((d-0.05)*10.5) - 12.0*sin(pow(d,10.0)) > 0.0 ? 0.0 : 1.0 );
	
	// top right - 0, 1, 2, 3, 4, 7, 8, 9
	c += box( p, vec4( 0.9, 0.52, 0.1, 0.39 ) ) * ( pow( d-0.55, 2.0 ) > 0.02 ? 1.0 : 0.0 );

	return c;
}

void main( void )
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	float c= 0.0;
	c += ( time < 100.0 ) ? 0.0 : digit( p, vec4( 0.05, 0.4, 0.2, 0.35 ), time/100.0 );
	c += ( time < 10.0) ? 0.0 : digit( p, vec4( 0.27, 0.4, 0.2, 0.35 ), time/10.0 );
	c += digit( p, vec4( 0.5, 0.4, 0.2, 0.35 ), time );
	c += box( p, vec4( 0.71, 0.4, 0.03, 0.035 ) );
	c += digit( p, vec4( 0.75, 0.4, 0.2, 0.35 ), time*10.0 );

#if 0
	c += digit( p, vec4( 0.0, 0.1, 0.09, 0.1 ), 0.0 );
	c += digit( p, vec4( 0.1, 0.1, 0.09, 0.1 ), 1.0 );
	c += digit( p, vec4( 0.2, 0.1, 0.09, 0.1 ), 2.0 );
	c += digit( p, vec4( 0.3, 0.1, 0.09, 0.1 ), 3.0 );
	c += digit( p, vec4( 0.4, 0.1, 0.09, 0.1 ), 4.0 );
	c += digit( p, vec4( 0.5, 0.1, 0.09, 0.1 ), 5.0 );
	c += digit( p, vec4( 0.6, 0.1, 0.09, 0.1 ), 6.0 );
	c += digit( p, vec4( 0.7, 0.1, 0.09, 0.1 ), 7.0 );
	c += digit( p, vec4( 0.8, 0.1, 0.09, 0.1 ), 8.0 );
	c += digit( p, vec4( 0.9, 0.1, 0.09, 0.1 ), 9.0 );
#endif
	gl_FragColor = vec4( 0.0, c * 0.5, c, 1.0 )*(abs(sin(time*0.5))+0.5);
}