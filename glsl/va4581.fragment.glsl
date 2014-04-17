#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float dCircle(vec2 pos, float r)
{
	return length(pos) -r;
}

void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//suPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= 0.5;
	uPos.y -= 0.5;
	
	float vertColor = 0.0;
	for( float i = 0.0; i < 4.0; ++i )
	{
		uPos.x += sin( uPos.y + time ) * 0.3;
	
		float t =smoothstep(0.1,0.4,dCircle(uPos,0.1));
		vertColor += 1.0/t/100.0;
	}
	
	vec4 color = vec4( vertColor, vertColor, vertColor * 2.5, 1.0 );
	gl_FragColor = color;
}