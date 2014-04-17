#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;

	float color = 0.0;
	color += distance(position.x, position.y) * 3.0;
	color += distance(-position.x, position.y) * 3.0;
	color += distance(position.x, -position.y) * 3.0;
	//color += sin(time*color);
	color += sin(pow(color,10.0));
	
	
	gl_FragColor = vec4( color * sin( time - 1.0 )+0.5 * 0.5, color *sin(time - 2.0) * 1.0+0.5, color * sin(time)+0.5, 1.0 );

}