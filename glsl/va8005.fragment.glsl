#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	for(int i=0; i<10; ++i){
	color += sin(position.x * 10.0 * time) + sin(position.y * 10.0);
	color += sin(position.x * 10.0 + time) + sin(position.y * 10.0+time);
	}
	
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ).brg, 1.0 );

}