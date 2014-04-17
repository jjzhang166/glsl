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
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= 0.5;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 10.0; ++i )
	{
		float t = time * (.8);
	
		uPos.y -= sin( uPos.x*(i+1.0) + t+i/5.0 ) * 0.1;
		float fTemp = abs(1.0 / uPos.y / 1900.0);
		vertColor += fTemp;
		color += vec3( fTemp*(15.0-i) - 1.0, pow(fTemp, 1.0/i) + 0.0, pow(fTemp,i)*.5 );
	}
	
	vec4 color_final = vec4(color, .2);
	gl_FragColor = color_final;

}