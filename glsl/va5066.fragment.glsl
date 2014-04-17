#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//uPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	if (uPos.y > 0.25) { uPos.y -= 0.25; }
	else { uPos.y -= 0.75; }
	
	float vertColor = 0.0;
	for( float i = 0.0; i < 1.0; ++i )
	{
		float t = time * (i + 0.9);
	
		uPos.y += sin( uPos.x + t ) * 0.3;
	
		float fTemp = abs(1.0 / uPos.y / 500.0);
		vertColor += fTemp;
	}
	
	vec4 color = vec4( vertColor, vertColor, vertColor * 2.5, 1.0 );
	gl_FragColor = color;
}