#ifdef GL_ES
precision mediump float;
#endif
//mod by zSilas

uniform float time;
uniform vec2 resolution;


void main( void )
{
	
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//uPos -= vec2((resolution.x/resolution.y)/2.0, (resolution.x/resolution.y)*0.3);//shift origin to center
	
	uPos.y -= 1.2069;
	float dx = exp( uPos.x*0.085);
     	float dy =exp( uPos.y*0.1);
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	const float k = 5.;
	
	float t = time * exp(1.0*dx) * (1.0);
	
	
	for( float i = k-2.; i >0.; --i )
	{
		
	
		uPos.y += exp(1.681*dy) * sin( uPos.x*exp(i) - t) * 0.01;
		float fTemp = abs(cos(t/4.)*0.01 / uPos.y);
		vertColor += fTemp-t;
		color += vec3( fTemp*(i*0.08) , sin(t/4.)*fTemp*i/k, pow(fTemp,0.93)*1.2*sin(t/6.) );
	}
	
	for( float i = 0.; i<k; ++i )
	{
		
	
		uPos.y += exp(1.681*dy) * sin( uPos.x*exp(i) - t) * 0.01;
		float fTemp = abs(cos(t/4.)*0.01 / uPos.y);
		vertColor += fTemp-t;
		color += vec3( fTemp*(i*0.08) , sin(t/4.)*fTemp*i/k, pow(fTemp,0.93)*1.2*sin(t/6.) );
	}
	t+=1.681;
	
	for( float i = k-2.; i >0.; --i )
	{
		
	
		uPos.y += exp(1.681*dy) * sin( uPos.x*exp(i) - t) * 0.01;
		float fTemp = abs(cos(t/4.)*0.01 / uPos.y);
		vertColor += fTemp-t;
		color += vec3( fTemp*(i*0.08) , sin(t/4.)*fTemp*i/k, pow(fTemp,0.93)*1.2*sin(t/6.) );
	}
	
	for( float i = 0.; i<k; ++i )
	{
		uPos.y += exp(1.681*dy) * sin( uPos.x*exp(i) - t) * 0.01;
		float fTemp = abs(cos(t/4.)*0.01 / uPos.y);
		vertColor += fTemp-t;
		color += vec3( fTemp*(i*0.08) , sin(t/4.)*fTemp*i/k, pow(fTemp,0.93)*1.2*sin(t/6.) );
	}	
	
	vec4 color_final = vec4(color, 5.0);
	gl_FragColor = color_final;
}