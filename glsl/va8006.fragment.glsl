#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	for(int i=0; i<10;++i){
		color -= sin(position.x*5.0)*cos(position.y*10.0) + tan(position.y*1.25);
		color += (time);
		
	}
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 ).bbba;

}