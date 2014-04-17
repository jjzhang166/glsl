#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 cmul(const vec2 c1, const vec2 c2)
{
	return vec2(
		c1.x * c2.x - c1.y * c2.y,
		c1.x * c2.y + c1.y * c2.x
	);
}
void main( void )
{
	vec2 resolution = vec2(320,240);
	//float curSize = abs(sin(time/16.0))*150.0;
	//resolution = vec2(320.0 - curSize , 240.0 - curSize /2.0 );
	
		
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
     
	//uPos.x -= 1.4 + mod(time, 26.0)/10.0;
	uPos.x -= 1.4 + sin(time/5.0)/20.0;
	uPos.y -= 1.1 + sin(time/5.0)/20.0;
		
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 3.0; ++i )
	{
		float t = 0.2 + sin(time/12.0)*7.8 *(0.08) + 1.0;
	
		vec2 origPos = uPos;
		uPos.y += sin( uPos.y/2.0+uPos.x/2.0*(i/0.5+1.0)+t ) * 2.1;
		//uPos.x += sin( uPos.y/2.0+uPos.x/1.0*(i/0.5+1.0)+t ) * 2.1;		
		uPos =  cmul(origPos, uPos);
		
		float fTemp = abs(1.0 / uPos.y/0.09 / 100.0);
		vertColor += fTemp;
		//color += vec3( fTemp*i/5.0, fTemp*i/40.0, pow(fTemp,i/24.0)/64.0 );
		color += vec3( fTemp*i/12.0, 0.0, 0.0 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
}