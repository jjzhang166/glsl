#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	const float max = 2.0;
	
	float x = gl_FragCoord.x / resolution.x * 2.0 * max - 1.4*max;
	float y = resolution.y/resolution.x * gl_FragCoord.y / resolution.y  * 2.0 * max - 0.5* max;
	
	vec2 c = vec2(x,y);
	
	const int num_iter=40;
	float num_inside = 0.0;
	vec2 z = c;
	float sin_time = 0.0;
	for(int i = 0; i < num_iter;i++){
		z = vec2(z.x*z.x-z.y*z.y, 2.0*z.x*z.y) + c;
		
		if(z.x*z.x+z.y*z.y<4.0){
			num_inside += 1.0;
		} else {
			break;
		}
	}
	
	float color = num_inside/(float(num_iter));
	
	float abs_sqrt = z.x*z.x+z.y*z.y;
	
	gl_FragColor = vec4( sin(color*10.0 + time*0.83)*abs_sqrt*0.5, sin(color*5.0+time*1.442), cos(color*8.0 + time * 0.132434), 1.0 );

}