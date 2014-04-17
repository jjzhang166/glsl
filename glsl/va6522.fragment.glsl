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
	
	uPos.y -= 0.0;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	const float k = 7.;
	for( float i = 1.0; i < k; ++i )
	{
		float t = time * exp(0.1*mouse.x) * (1.0);
	
		uPos.y += exp(3.0*mouse.y) * sin( uPos.x*exp(i) - t) * 0.01;
		float fTemp = abs(1.0/(50.0*k) / uPos.y);
		vertColor += fTemp;
		color += vec3( fTemp*(i*0.03), fTemp*i/k, pow(fTemp,0.93)*1.2 );
	}
	
	vec4 color_final = vec4(color, 65.0);
	gl_FragColor = color_final;
}