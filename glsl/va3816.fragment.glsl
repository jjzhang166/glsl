#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

////////////////////////////
//note: banding removal test
////////////////////////////


//note: normalized rand, [0;1]
float nrand( vec2 n ) {
  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

//note: outputs x truncated to n levels
float trunc( float x, float n )
{
	return floor(x*n)/n;
}

void main( void )
{
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	float col = mix( 0.0, 0.5, pos.x );
	vec3 outcol;

	if ( pos.y > 3.0/4.0 )
	{
		//note: noise by 1 grayscale
		float rnd = nrand(pos+vec2(time*0.0001));
		outcol = vec3( col + rnd / 255.0 );

		outcol += step( 0.97, pos.x ) * vec3( 0.25, 1.0, 1.0 );
	}
	else if( pos.y > 2.0/4.0)
	{
		//note: 2x2 ordered dithering
		vec4 D2 = vec4( 3, 1, 0, 2 ) / 255.0 / 4.0;
		
		int i = int( mod( gl_FragCoord.x, 2.0 ) );
		int j = int( mod( gl_FragCoord.y, 2.0 ) );
		int idx = i + 2*j;
		float d = 0.0;
		d += (idx == 0) ? D2.x : 0.0;
		d += (idx == 1) ? D2.y : 0.0;
		d += (idx == 2) ? D2.z : 0.0;
		d += (idx == 3) ? D2.w : 0.0;
		
		col += 0.5 / 255.0;	
		float e = col - trunc( col, 255.0 ); // = fract( 255.0 * col ) / 255.0;
		outcol = vec3( ( e > d ) ? ceil(col*255.0)/255.0 : floor(col*255.0)/255.0 );
		
		outcol += step( 0.97, pos.x ) * vec3( 1.0, 0.25, 0.25 );;
	}
	else if( pos.y > 1.0 / 4.0 )
	{
		//note: offset r, g, b
		outcol = vec3(col, col + 1.0/3.0/256.0, col + 2.0/3.0/256.0);
		outcol += step(0.97, pos.x) * vec3( 0.25, 1.0, 0.25 );
	}
	else
	{
		//note: "luminance" incr
		float e = col - trunc( col, 255.0 ); // = fract( 255.0 * col ) / 255.0;
		vec2 rg = mod( floor( vec2(4.0,2.0) * e * 255.0), 2.0 );
		
		outcol = floor( col*255.0 )/255.0 + vec3(rg,0.0) / 255.0;
		outcol += step(0.97, pos.x ) * vec3( 0.25, 0.25, 1.0 );
	}
	
	if ( mod(pos.y * 16.0, 4.0) < 2.0 )
	{
		//note: straight gradient
		outcol = vec3( trunc(col + 0.5/255.0, 255.0) );
	}

	gl_FragColor = vec4( outcol, 1.0 );

}
