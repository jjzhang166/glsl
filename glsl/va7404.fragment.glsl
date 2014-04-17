#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 p1 = vec2(10.,20.);
	vec2 p2 = vec2(30., 20.);
	vec2 uPos = vec2( p1/p2 );//normalize wrt y axis
	//suPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= 5.;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.);
	float vertColor = 0.;
	for( float i = 0.0; i < 2.; ++i )
	{
		uPos.y += (sin( uPos.x*(exp(i+1.))  )) * 0.2;
		uPos.x += (sin( uPos.y*(exp(i))  )) * 0.2;
		
		float fTemp = abs(1.0 / uPos.y / 100.0);
		color += vec3( fTemp*(1.0-i)/8.0, fTemp*i/4.0, pow(fTemp,0.99)*1.2 );
		color += vec3( fTemp*(1.0-i)/4.0, fTemp*i/4.0, ( pow(fTemp,0.7)*1.2 / 5.) );
		color += vec3( fTemp*(1.0-i)/4.0, fTemp*i/4.0, ( fTemp/2.*4. / 5.) );
	}
	
	//vec4 color_final = 
	gl_FragColor = vec4(color, 1.0);//color_final;
}