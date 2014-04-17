#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color = position.x;
	
	float m1 = position.x;
	float m2 = m1*m1;
	
	float mean = m1;
	float var = m1 - m2;

	float t = mouse.x*4.0;
	float d = t - m1;
	if (t <= m1)
		color = 1.0;
	else
	{
		color = var / (var + d*d);
		
		if (color < var)
			color = 0.0;
		
		//if (sqrt(var) < 0.4)
		//	color =0.0;
		//color = sqrt(var)*2.0;
		//if (t > m1+sqrt(var)*1.0)
		//	color = 0.0;
		//else
		//	color = 1.0;
		
//		color = (t - sqrt(var)*2.0);
//		if (t > m1 + sqrt(var)*2.0)
//			color = pow (color, 2.0);
//		color *= sqrt(var)*2.0;
		
		//color = 0.0;
	}
		
	if (position.y < 0.1)
		color = mod(position.x*4.0, 1.0);
	
	gl_FragColor = vec4(color, color, color, 1.0);
	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}