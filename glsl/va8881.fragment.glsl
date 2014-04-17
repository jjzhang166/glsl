#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2  pos = gl_FragCoord.xy;
	float index = 0.0;
	float accum = 0.0;
	float radius = min(resolution.x, resolution.y);
	float factor = 20.0/1280.0*resolution.x;
	
	vec2 center = resolution * 0.5;
	
	for( int i=0; i<10; i++) {
	  index += 0.251;
		
	  vec2 sferePos = vec2(center.x + sin(time*index) * cos(time*(3.0-index*1.23)) * radius * 0.3, 
			       center.y + cos(time*(5.0-index)) * radius * 0.3);
	
	  accum += factor*sin(time*index)/distance(gl_FragCoord.xy, sferePos);
	}
		
	gl_FragColor = vec4(
		accum*2.5,
		accum*0.95,
	        accum*0.35, 1.0 );
}