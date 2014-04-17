#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//suPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= 0.5;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 10.0; ++i )
	{
		float t = time * (2.5);
	
		uPos.y += sin( uPos.x*(i+1.0) + t+i/5.0 ) * 0.1;
		float fTemp = abs(1.0 / uPos.y / 990.0);
		vertColor += fTemp;
		color += vec3( fTemp*(11.0-i)/2.0, fTemp*i/14.0, pow(fTemp,0.99)*4.5 );
	}
	
	vec4 color_final = vec4(color, 2.0);
	gl_FragColor = color_final;

}