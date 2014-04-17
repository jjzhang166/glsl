#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy );

	float x = 0.0;
	float y = 0.0;
	
	float nx = (position.x / (resolution.x / 3.5)) -2.5;
	float ny = (position.y / (resolution.y / 2.0)) -1.0;
	
	float iteration = 0.0;
	float maxIteration = 100.0;

	float t = time;

	float intSize = 20.0;
	float intStart = 2.0;
	
	for(int i=0; i<100; i++)
	{
		if((x*x + y*y < 4.0) && iteration < maxIteration){
			
			
			float pwr = intStart + intSize * abs(sin(t / 3.0));
			
			float r = pow(sqrt(x * x + y * y),pwr);
			float angle = atan(y,x) * pwr;
			
			x = r * cos(angle) + nx;
			y = r * sin(angle) + ny;
			
    			iteration++;
		}
	}
	
	float r = abs(sin(iteration / maxIteration));
	float g = abs(time * cos(iteration / maxIteration));
	float b = abs(sin(iteration / maxIteration) + 3.14 / 6.0);
	

	gl_FragColor = vec4( vec3( r, g, b ), 1.0 );

}