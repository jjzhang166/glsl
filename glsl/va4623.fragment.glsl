#ifdef GL_ES
precision mediump float;
#endif
// mods by dist, shrunk slightly by @danbri
// Extended to show Fannys by @TimIsMint,@BruceIsAlsoMint
precision mediump float;
uniform float time;
uniform vec2 mouse, resolution;
void main(void) 
{
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= 0.5;
	
	float midu = uPos.y;
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.; i < 6.; ++i ) 
	{
		uPos.y -= pow(sin( uPos.x*(i) + (time * i * i * 0.1) ), 8.0 ) * 0.15;
		float fTemp = pow(abs(0.5 / uPos.y / 50.0), 1.4);
		vertColor += fTemp;
		color += vec3( fTemp*(7.0-i)/7.0, fTemp*i/10.0, pow(fTemp,0.9)*1.5 );
		
	}
	
	uPos.y = midu;
	
	for( float i = 0.; i < 6.; ++i ) 
	{
		uPos.y += pow(sin( uPos.x*(i) + (time * i * i * 0.1) ), 8.0 ) * 0.15;
		float fTemp = pow(abs(0.5 / uPos.y / 50.0), 1.4);
		vertColor += fTemp;
		color += vec3( fTemp*(7.0-i)/7.0, fTemp*i/10.0, pow(fTemp,0.9)*1.5 );
		
	}
	
	
	
	
	
	
	
	gl_FragColor = vec4(color, 1.0);
}