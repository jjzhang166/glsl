#ifdef GL_ES
precision mediump float;
#endif


varying vec2 surfacePosition;
uniform float time;
uniform vec2 resolution;


const float ZOOM = 3.0;
const float ITERATIONS = 2048.0;


void main(void)
{
	
	vec2 p = ZOOM * gl_FragCoord.xy / resolution.xy - 2.0;  
	vec2 z = p;
	
	
		
	float e;
	float c = 0.0;
	for(float i = .0; i < ITERATIONS; i++)
	{
		if(e < 1024.0)
		{
			z = p + vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y);
			e = dot(z,z);
			c+=1.0;
		}
	}
	
	c = c  - log2(e);
	c = sqrt(c/ITERATIONS);
	float r = sin(c + 0.125);
	float g = sin(c + 0.250);
	float b = sin(c + 0.750);
	gl_FragColor = vec4(r,g,b,1.0 );
}