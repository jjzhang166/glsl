// My first GLSL shader
// The Mandelbrot fractal



#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	
	float color = 0.0;
	float x0 = position.x/400.0 - 1.5;
	float y0 = position.y/400.0 - 1.0;
	float xtemp = 0.0;

	float x = 0.0;
  	float y = 0.0;

	int done = 0;

	
	for (int iteration = 0; iteration < 1000; iteration++)    {
		xtemp = x*x - y*y + x0;
		y = 2.0*x*y + y0;

		x = xtemp;
		if(x*x + y*y >= 4.0) {
			done = iteration;
			break;
		}
    	}
	
	
	if (done < 1000){
		color = float(done)*15.0/255.0;
	}
	else {
		color = 0.0;
	}
	
	
	
	gl_FragColor = vec4(color/(sin(time*0.9)+2.0), color/(sin(time*1.1)+2.0), color/(sin(time)+2.0), 1.0 );
}