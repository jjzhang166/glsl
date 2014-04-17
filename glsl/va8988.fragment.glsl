// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void )
{
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 uPos = pos;
	uPos.y -= 0.5;
	
	vec3 color = vec3(.05);
	const float k = 3.0;
	for( float i = k; i > 1.; --i )
	{
		float t = time * (1.0);
	
		//uPos.y += sin( uPos.x*exp(i) - t) * 0.15;
		float fTemp = abs(1.0/(50.0*k) / uPos.y);
		color += vec3( fTemp*(i*1.5), fTemp*i/k*2.0, pow(fTemp,0.93)*0.9 );
	}
	
	gl_FragColor = vec4(color, 1.0);
}
