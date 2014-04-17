#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	position -= mouse;
	position *=5.0;
	position.x += 5.0;
	position.x *= resolution.x / resolution.y;
	float color = 0.0;

	for(float i = 0.0; i < 5.0; i++)
	{
		position.x += sin(2.0 * sin(length(position.y)));
		position += 5.0 * mouse;
		color += sin(0.6 * sin(length(position) + position.x + i * position.y*0.5 + sin(i + position.x + time )) + sin(2. * cos(sin(position.y * 2.0 + position.x) * 0.5)));
		color = sin(color*1.5);
		position.y += color*1.5;
		position.x -= sin(position.y - cos(dot(position, vec2(color, sin(color*6.0)))));
		
	}
	color = abs(color);
	color *= 0.8;
	
	gl_FragColor = vec4(pow(vec3(1.0 - color), vec3(1.5, 1.2, 0.9
						 )), 1.0 );

}