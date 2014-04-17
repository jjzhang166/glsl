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
	const float k = 3.1;
	for( float i = k; i > 1.; --i )
	{
		float t = time * (1.0);
	
		uPos.y += sin( uPos.x*exp(i) - t) * 1.01;
		float fTemp = abs(1.0/(100.0*k) / uPos.y * 2.0);
		color += vec3( fTemp*(i*1.9), fTemp*i/k*2.5, pow(fTemp,0.73)*0.9 );
	}
	
	gl_FragColor = vec4(color, 0.1);
}
