#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float randA(vec2 co){
    return fract(sin((co.x+co.y*1e3)*1e-3) * 1e5);
}

float randB(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//note: try all resolutions, different structures become apparent
void main( void )
{
	float r;
	float ofs = fract(time);
	if ( gl_FragCoord.y/resolution.y>0.5 )
		r = randA( gl_FragCoord.xy+vec2(0.0,0.83*ofs) );
	else
		r = randB( gl_FragCoord.xy/resolution.xy+vec2(ofs,0.0) );
	
	gl_FragColor = vec4(r, r, r, 1.0);

	
	if ( abs(gl_FragCoord.y/resolution.y-0.5)<0.01 )
	{
		gl_FragColor = vec4( 1, 1, 1, 1 );
	}
}