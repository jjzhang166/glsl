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
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((0.5*resolution.x/resolution.y), 0.5);//shift origin to center
	uPos *= 3.0;
		
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 4.0; ++i )
	{
		float t = time *(0.1) + 1.0;
	
		vec2 origPos = uPos;
		uPos.y += sin( uPos.y/2.0+uPos.x/2.0*(i/0.5+1.0)+t ) * 1.1;
		//uPos.x += sin( uPos.y/2.0+uPos.x/1.0*(i/0.5+1.0)+t ) * 2.1;
		
		uPos =  cmul(origPos, uPos);
		
		float fTemp = abs(1.0 / uPos.y/0.09 / 100.0);
		vertColor += fTemp;
		color += vec3( fTemp*i/5.0, fTemp*i/40.0, pow(fTemp,i/24.0)/64.0 );
		//color += vec3( fTemp*i/4.0, 0.0, 0.0 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
}