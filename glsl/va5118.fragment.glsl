// Conway's Game of Life, by Gabriel Leung

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float countNeighbours()
{
	vec2 left = vec2( gl_FragCoord.x -1., gl_FragCoord.y  );
	vec2 right = vec2( gl_FragCoord.x +1., gl_FragCoord.y  );
	vec2 up = vec2( gl_FragCoord.x, gl_FragCoord.y +1.  );
	vec2 down = vec2( gl_FragCoord.x, gl_FragCoord.y -1. );	

	vec2 upleft = vec2( gl_FragCoord.x -1., gl_FragCoord.y+1.  );
	vec2 upright = vec2( gl_FragCoord.x +1., gl_FragCoord.y+1.  );
	vec2 downleft = vec2( gl_FragCoord.x-1., gl_FragCoord.y -1.  );
	vec2 downright = vec2( gl_FragCoord.x+1., gl_FragCoord.y -1. );	
	
	
	float oldLeft = texture2D(backbuffer, left/resolution).r;
	if( oldLeft > 0. ){ oldLeft = 1.; }
	float oldRight = texture2D(backbuffer, right/resolution).r;
	if( oldRight > 0. ){ oldRight = 1.; }
	float oldDown = texture2D(backbuffer, up/resolution).r;
	if( oldDown > 0. ){ oldDown = 1.; }
	float oldUp = texture2D(backbuffer, down/resolution).r;	
	if( oldUp > 0. ){ oldUp = 1.; }
	
	float oldul = texture2D(backbuffer, upleft/resolution).r;
	if( oldul > 0. ){ oldul = 1.; }
	float oldur = texture2D(backbuffer, upright/resolution).r;
	if( oldur > 0. ){ oldur = 1.;}
	float olddl = texture2D(backbuffer, downleft/resolution).r;
	if( olddl > 0. ){ olddl = 1.;	}
	float olddr = texture2D(backbuffer, downright/resolution).r;		
	if( olddr > 0. ){ olddr = 1.;	}
	
	return oldLeft + oldRight + oldDown + oldUp + oldul + oldur + olddl + olddr;
}

vec4 wavysin()
{
		vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//uPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= 0.5;
	
	float vertColor = 0.0;
	for( float i = 0.0; i < 1.0; ++i )
	{
		float t = time * (i + 0.9);
	
		uPos.x += sin( uPos.y + t ) * 0.3;
	
		float fTemp = abs(1.0 / uPos.x / 1000.0);
		vertColor += fTemp;
	}
	
	return vec4( vertColor*2., 0, 0 , 1.0 );
}

void main( void ) {
	
	vec2 middle = vec2(resolution.x/2.,resolution.y/2.);
	vec3 outColor = vec3(0.);
	
	float n = countNeighbours();		
	
	if( (n >= 2.) && (n < 3.) )
	{
		outColor.x = texture2D(backbuffer, gl_FragCoord.xy/resolution).r;
	}
	
	if( (n < 2.) || (n > 3.) )
	{
		outColor.x = 0.;
	}
	
	if( (n > 2.9) && (n < 3.3) )
	{
		outColor.x = 1.;
	}

	if( (n > 2.9) && (n < 3.2) )
	{
		outColor.y = 1.;
	}
	vec2 mousePos = mouse * resolution;
	if( distance( gl_FragCoord.xy, mousePos) < 15. )
	{
		outColor.x = 1.;
	}
	
	if( distance( gl_FragCoord.xy, mousePos) < 8. )
	{
		outColor.x = 0.;
	}
	
	if( distance(gl_FragCoord.xy, middle) < 10. )
	{
		outColor.x = 1.0;	
	}
	
	if( time < 3. )
	{
		outColor.x = 0.;
	}
	
	vec4 returnC = vec4(outColor,0.);	
	
	gl_FragColor = returnC;//ec4(outColor,0.);

}
