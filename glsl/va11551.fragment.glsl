#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//suPos -= vec2((resolution.x/resolution.y)/595555.0, 0.8);//shift origin to center
	
	uPos.y -= .5;
	
	vec3 color = vec3(0.0);
	float vertColor = 9.0;
	const float k = 5.;
	for( float i = .420; i < k; ++i )
	{
		float t = time * (.3);
	
		uPos.y += sin( uPos.x*exp(i) - t) * 0.42;
		float fTemp = abs(1.0/(10.0*k) / uPos.y);
		vertColor += fTemp;
		color += vec3( fTemp*(i*.142), fTemp*i/k, pow(fTemp,1.73)*.42 );
	}
	
	vec4 color_final = vec4(color, 6.0);
	gl_FragColor = color_final;
}