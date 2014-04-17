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
	
	float vertColor = 0.1;
	float qTime = time/25.0;
	for( float i = 0.0; i < 5.0; ++i )
	{
		float t = qTime * i;
	
		uPos.x += clamp(sin( (uPos.y + t)* 10. ),-0.025,0.025);
	
		float fTemp = 1.0/abs(uPos.x )/1000.0;
		vertColor += fTemp;
	}
	
	gl_FragColor = vec4( vertColor*3.0, vertColor, vertColor , 1.0 );
}