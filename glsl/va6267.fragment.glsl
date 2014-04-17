#ifdef GL_ES
precision mediump float;
#endif

#define MAX_IT 40.0

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
	float maxIteration = 60.0;

	float scale = 0.4 + sin(time)/10.0;
	float timeF = 30.0;
	
	x = (nx + 0.8) * scale;
	y = (ny) * scale;
	
	float angle = time / 4.0;
	
	float tx = cos(angle) * x - sin(angle) * y;
	float ty = sin(angle) * x + cos(angle) * y;
	
	x = tx;
	y = ty;
	
	for(int i=0; i<40; i++)
	{
		if((x*x + y*y < 4.0) && iteration < maxIteration){
			float newX = x*x - y*y + cos(time / timeF) / 1.3;
			y = 2.0 * x * y + sin(time / timeF) / 1.3;
			x = newX;

    			iteration++;
		}
	}
	
	float pixelColour = (iteration/maxIteration);
	
	gl_FragColor = vec4( vec3(sin(pixelColour * 10.0), cos(pixelColour + 2.0), sin(pixelColour * 10.0 + 0.5) ), 1.0 );

}