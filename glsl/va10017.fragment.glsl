#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float looptime = 1.0;//0.5 + 0.5 * (time/10.0 - floor(time/10.0));
		
	float dist_from_origin = sqrt( position.x * position.x  + position.y * position.y);
	
	float frequency = dist_from_origin / sqrt(2.0);
	
	float k = 2.0 * 3.14159 * 250.0 * looptime;
	
	float color = 0.5 * (1.0 + cos(k * frequency * frequency));

	gl_FragColor = vec4(color,color,color,1.0);

}