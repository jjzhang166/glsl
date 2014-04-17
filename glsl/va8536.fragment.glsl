#ifdef GL_ES
precision highp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
const float ITERATIONS = 1030.0;

vec2 square(vec2 z) {

	return vec2 ((z.x*z.x - z.y*z.y) , (2.0*z.x*z.y));
}

float sqLength(vec2 z) {
	
	return z.x*z.x + z.y*z.y;
}
void main( void ) {
	
	//vec2  offset = vec2(0.0,0.0);
	vec2  offset = mouse-vec2(0.5,0.5);
	float scale = 0.5;
	
		
	float scaleCoord = min(resolution.x,resolution.y);
	vec2  middle = resolution / (2.0 * scaleCoord);
	
	vec2 c = (((gl_FragCoord.xy/scaleCoord) - middle)) / scale + offset;
	vec2 z = vec2(0.0,0.0);
	
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	for (float i = 0.0; i < ITERATIONS; i ++) {
		z = square(z) + c;
		if(sqLength(z) > 4.0){
			color = vec4(pow(i/ITERATIONS,0.4),0.0,0.0,1.0);
			break;
		}
	}
	
	gl_FragColor = color;
}