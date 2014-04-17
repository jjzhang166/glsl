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
	
	uPos.x -= .7;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 45.0; ++i )
	{
		float t = time * (0.3);
	
		uPos.y += sin( uPos.x*i + t+i/.4 ) * 0.8;
		float fTemp = abs(.05 / uPos.y / 100.0);
		vertColor += fTemp;
		color += vec3( fTemp*(40.0-i)/30.0, fTemp*i/.0, pow(fTemp,8.5)*1.5 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
}