#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{

	vec2 position = ( gl_FragCoord.xy / vec2(1000, 1000));

	float color = 0.0;
	color += sin(time + position.x);
	
	//position += color;
	
	color += cos(time + position.y);
	color -= cos(time * 0.25);
	color *= cos(time) * time + position.y;
	
	color += position.y / 3.0;
	
	gl_FragColor = vec4(color * sin(time), color * sin(color), color * position.y , 1.0);

}