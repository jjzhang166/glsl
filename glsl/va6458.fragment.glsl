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
	//suPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	const float k = 2.;
	for( float i = 0.2; i < k; i += 0.3 )
	{
		float t = time * exp(0.1) * (1.0);
	
		uPos.y += exp(0.1) * sin( uPos.x*exp(i) - t) * 0.04;
		float fTemp = abs(1.0/(50.0*k) / uPos.y);
		vertColor += fTemp;
		color += vec3( fTemp*(i*0.03), fTemp*i/k, pow(fTemp,0.93)*1.2 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
}