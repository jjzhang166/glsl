#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );
	
	uPos.x -= 0.5;
	
	float vertColor = 0.0;
	for( float i = 0.0; i < 10.0; ++i )
	{
		float t = time * (i + 0.9);
	
		uPos.y += sin( uPos.x + t )/20.-0.5;
	
		float fTemp = abs(1.0 / uPos.y/1000.0 );
		vertColor += fTemp;
	}
	
	vec4 color = vec4( vertColor, vertColor, vertColor*(sin(time)*2.0+1.0), 1.0 );
	gl_FragColor = color;
}