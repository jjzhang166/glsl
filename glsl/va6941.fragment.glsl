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
	
	uPos.x -= 0.5;
	
	float vertColor = 0.02;
	for( float i = 0.0; i < 30.0; i++ )
	{
		float t = time * (i*0.1 + 0.3);
	
		uPos.x += sin( uPos.y * 30.0 + t ) * 0.1;
	
		float fTemp = (.002 / uPos.x);
		vertColor += fTemp;
	}
	
	vec4 color = vec4( vertColor*444.5, vertColor, vertColor, 1.0 );
	gl_FragColor = color;
}