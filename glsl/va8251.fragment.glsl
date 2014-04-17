#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.141592;

void main( void ) {
	
	vec2 position = (gl_FragCoord.xy);
		
	vec2 center;
	vec2 distance;
	float hyp;
	vec4 totalColor;
	
	float ft = time * 1.0;
	
	for(int e = 0; e<80; e+=1)
	{
		float ei = float(e+1);
		for(int i = 0; i<10; i++)
		{			
			float ti = float(i)/100.0;
			
			center = resolution.xy / 2.0;
			center.x += sin((ft * ei / 2.0) - (PI / 4.0 * ti))*ei*5.0;
			center.y += cos((ft * ei / 2.0) - (PI / 4.0 * ti))*ei*5.0;
			
			distance = position - center;
			distance /= abs(cos(ft*3.759))/60.0+0.3;
			
			hyp = sqrt(pow(distance.x,2.0) + pow(distance.y,2.0));
			hyp = hyp / 1.0;
			hyp = 1.0 / hyp;
		
			totalColor += vec4(hyp/1.2*abs(sin(ft*3.759*2.0+(PI/3.0))), 
					   hyp/1.9*abs(sin(ft*3.759*2.0+(2.0*PI/3.0))), 
					   hyp/0.5*abs(sin(ft*3.759*2.0+(0.0*PI/3.0))), 
					   1.0);
		}
	}
	
	

	
	gl_FragColor = totalColor;
}