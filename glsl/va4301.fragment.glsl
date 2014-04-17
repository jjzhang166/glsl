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
	
	uPos.x -= 0.913;
	
	float vertColor = 0.0;
	for( float i = 0.0; i < 15.0; ++i )
	{
		float t = time * (i);
	
		uPos.x += sin( exp(uPos.y) + log(t) ) * exp(0.03) + 0.999;
	
		float fTemp = abs(1.0 / uPos.x / 100.0);
		vertColor += fTemp;
	}
	
	vec4 color = vec4( vertColor*uPos.y, vertColor * sin(time+uPos.x), vertColor * 2.5, 1.0 );
	gl_FragColor = color;
}