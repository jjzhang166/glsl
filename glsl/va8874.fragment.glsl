precision mediump float;

uniform float time;


void main( void ) {
	vec2  pos = gl_FragCoord.xy;
	vec2  cPos;
	float index = 0.0;

	
	float accum = 0.0;
	float tmp;
	
	for( int i=0; i<5; i++) {
	  index += 1.112;
	  vec2 sferePos = vec2(300.0+sin(time*index)*200.0-cos(time/index), 300.0+cos(time*(5.0-index))*200.0);
	  tmp = 7000.0/length(sferePos - gl_FragCoord.xy);
	  tmp *= tmp;
	  accum += tmp * 0.0001;
	}

		
	gl_FragColor = vec4(
		accum>0.45?cos(time*1.001):sin(time*1.001),
		accum>0.55?sin(time):cos(time),
		accum>0.75?1.0:cos(time*3.001), 1.0 );
}