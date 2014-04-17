#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;



void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float f = clamp(1.0 - abs(position.y - (sin(position.x * 3.0 + time) * 0.3 + 0.5)) * 10.0, 0.0, 1.0);
	float f2 = clamp(1.0 - abs(position.y - (sin(position.x + time * 0.4) * 0.3 + 0.5)) * 10.0, 0.0, 1.0);
	
	gl_FragColor.rgb = vec3(0.0, 0.6, 1.0) * f + vec3(1.0, 0.4, 0.0) * f2;

	float m = 0.0;
	vec3 s = vec3(0.0);
	
	for(float x = -0.1; x <= 0.1; x += 0.05)
	{
		for(float y = -0.1; y <= 0.1; y += 0.05)
		{
	
			vec2 p = position + vec2(x, y);
			float t = cos(p.x * 5.0 - time) * 2.0 - sin(p.y * 7.0 + time) * 2.0 + (p.x * p.y) * 2.0;	
			s += texture2D(backbuffer, position + vec2(cos(t) * 0.01, sin(t) * 0.01)).rgb;
			m++;
		}
	}

	
	
	gl_FragColor.rgb = (s / m) * 0.95 + gl_FragColor.rgb * 0.05;
	
	if(position.x < 0.01 || position.y < 0.01 || position.x > 0.99 || position.y > 0.99)
		gl_FragColor.rgb = vec3(0.0);
	
	gl_FragColor.rgb += clamp(pow(length(gl_FragColor.rgb), 100.0), 0.0, 1.0) * vec3(1.0) * 0.1;
	
	//gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(0.99));
	

}