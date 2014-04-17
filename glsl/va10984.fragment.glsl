#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 seed;
uniform float time;

float rand(vec2 n)
{
  return 0.5 + 0.5 * 
     fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

void main( void ) {

	/*vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;*/
	
	int dobre = 0, zle = 0;
	vec2 point;
	point.x = rand(seed);
	point.y = rand(seed);
	if (pow(point.x, 2.0) + pow(point.y,2.0) <= 1.0)
	{
		dobre++;
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
		
	} else {
		zle++;
		gl_FragColor = vec4(0.0);
	}
	

}