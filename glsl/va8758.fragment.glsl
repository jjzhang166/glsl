#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float noise(float x)
{
	return fract(2222. * sin(x * 1111.0 + 111.) + 11.);	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	position.x *= resolution.x / resolution.y;

	vec3 color;
	
	for(float i = 0.0; i < 9.0; i++)
	{
		
		color +=  max(vec3(0.0), (0.05 - abs(sin(position.x * i * 0.4 + time + i * 0.1)))) + max(vec3(0.0), (0.05 - abs(sin(position.y * i * 0.4 + time + i * 0.1))));
	}
	
	color *= 5.;
	gl_FragColor = vec4( color, 1 );

}