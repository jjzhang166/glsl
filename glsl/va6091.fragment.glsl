#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float color = 0.0;
	
	color += cos(position.x*tan(position.y + time/5.0) * sin(position.x * time / 10.0));
	color *= sin(position.y*tan(position.x + time/10.0) * sin(position.y * time / 10.0));
	color = sin(color);

	gl_FragColor = vec4( vec3( color * sin(time / 5.0 * color) , color * sin(time / 8.0) * 0.6 , sin( color + time / 3.0 ) * 0.9), cos(color) );

}