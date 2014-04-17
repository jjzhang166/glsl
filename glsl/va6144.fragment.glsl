#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{

	vec2 position = ( gl_FragCoord.xy  / vec2(50.0, sqrt(cos(time)) * 1000.0));

	float color = 0.0;
	
	color += cos(position.x) * cos(position.y);
	
	color += sin(position.xy);

	color += position.x / 10.0;
	
	color *= sin(position.x) * sin(time);
	color *= sin(position.y) * cos(time);
	
	//color *= sin(cos(time));
	
	gl_FragColor = vec4( vec3(sqrt(color) * sin(time) * cos(position.y), color / sin(position.x), color * sin(position.y) * cos(time)), 1.0 );

}