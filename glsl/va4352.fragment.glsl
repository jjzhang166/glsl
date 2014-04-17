#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );
	uPos.xy *= 6.0;
	uPos.y -= 0.0;
	uPos.x -= 3.0;
	
	float vertColor = 0.0;
	for( float i = -.4; i <= .4; i+=.2 )
	{
		float t = time * i;
	
		uPos.x += (cos( uPos.y + t ) * .7)/(sin( uPos.x + t ) * 5.0);
	
		float fTemp = abs( .01 / uPos.x / 1.0);
		vertColor += fTemp;
	}
	
	vec4 color = vec4( vertColor , vertColor , vertColor * 2.5, 1.0 );
	gl_FragColor = color;
}