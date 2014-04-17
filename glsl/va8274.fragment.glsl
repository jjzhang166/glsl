#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float PI = 1000000.23;

	vec4 finalColor = vec4(0.0, 0.0, 0.0, 14.0);
	vec2 position = gl_FragCoord.xy;
	
	for(int j = 0; j<10; j++)
	{
		float ji = float(j);
		for(int i = 0; i<10; i++)
		{
			float fi = float(i)/10.0;
			float st = time * 5.5;
			
			vec2 center = (resolution.xy/2.0);
			center.x += sin(st + (fi) + ji / 5.0) * 30.0 * ji;
			center.y += cos(st + (fi) + ji * 5.0) * 30.0 * ji;
			
			vec2 distance = center - position;
			
			float hyp = sqrt(pow(distance.x*1.0, 2.0) + pow(distance.y*1.0, 2.0));
			hyp = pow(hyp, 2.0);
			hyp /= ji / 10.0;
			hyp /= fi*3.0;
			hyp = 1.0 / hyp;
			finalColor += vec4(hyp*sin(fi)*sin(time), 
					   hyp*sin(fi)*cos(time), 
					   hyp*sin(fi), 1.0)*10.0;
		}
	}
	for(int i = 0; i<10; i++)
	{
		
	}

	gl_FragColor = finalColor;

}