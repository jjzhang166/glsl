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
	float maxIteration = 50.0 * mouse.x;
	
	for(int i=0; i<100; i++)
	{
		if((x*x + y*y < 4.0) && iteration < maxIteration){
			float xtemp = x*x - y*y + nx;
    			y = 2.0*x*y + ny;
			x = xtemp;

    			iteration++;
		}
	}
	
	float pixelColour = (iteration/maxIteration);
	
	gl_FragColor = vec4( vec3( pixelColour, pixelColour, pixelColour ), 1.0 );

}