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
	
	uPos.x -= 5.;
	uPos.y -= .7;
	
	vec3 color = vec3(0.);
	float vertColor = 0.;
	for( float i = 0.0; i < 3.; ++i )
	{
		float t = time * (1.9);
	
		//uPos.y += (sin( uPos.x*(exp(i+2.))  )) * 0.2;
		uPos.y += (sin( uPos.x*(exp(i+2.))  )) / 20.;
		
		uPos.x += (sin( uPos.y*(exp(i))  )) * 0.2;
		
		float fTemp = abs(1.0 / uPos.y / 100.0);
		vertColor += fTemp;
		//color += vec3( fTemp*(1.0-i)/8.0, fTemp*i/4.0, pow(fTemp,0.99)*1.2 );
		//color += vec3( fTemp*(1.0-i)/4.0, fTemp*i/4.0, ( pow(fTemp,0.5)*1.2 / 5.) );
		color += vec3( fTemp*(1.0-i)/4.0, fTemp*i/4.0, ( fTemp/2.*4. / 5.) );
	}
	
	//vec4 color_final = 
	gl_FragColor = vec4(color, 1.0);//color_final;
}