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
	//uPos -= mouse;
	uPos.x -= 0.5;
	
	float vertColor = 0.09;
	for( float i = 0.0; i < 5.0; ++i )
	{
		float t = time * (i + 0.9);
	
		uPos.x += sin(uPos.y + t) * 0.3;
		float fTemp = abs(.5 / uPos.x / 100.0);
		vertColor += fTemp;
	}
	
	vec4 color = vec4( vertColor, vertColor * 1.5, vertColor * 2.5, 0.1 );
	gl_FragColor = color;
}