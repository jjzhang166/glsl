precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define NUM_ITERATIONS 32

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy);
	pos.y *= 2.0; pos.y -= 1.0; pos.x *= 3.5; pos.x -= 2.5;

	float it = 0.0;
	vec2 z = vec2( 0 );
	vec2 ztemp = vec2( 0 );
	for (int i = 0; i < NUM_ITERATIONS; i++)
	{
	  if (length(z) > 2.0)
	    break;
	  ztemp.x = z.x * z.x - z.y * z.y + pos.x;
	  ztemp.y = 2.0 * z.x * z.y + pos.y;
	  z = ztemp;
	  it += 1.0;
	}
	
	float c = it / float(NUM_ITERATIONS);
	//float t2 = time * 1.;
	//c = sin( c + t2) * 2. + 0.4;
	float col  = sin(it / float(NUM_ITERATIONS) + time * 3.) * 2. - 1.;
	float col2 = cos(it / float(NUM_ITERATIONS) + time / 2.) * 2. - 1.;
	float col3 = sin(it / float(NUM_ITERATIONS) + time * 3.) * 2. - 1.;
	
	gl_FragColor = vec4(c, c, c, 1.);
}