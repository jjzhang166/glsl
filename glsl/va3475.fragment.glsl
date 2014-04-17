#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec4 calculateColor( void ){
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 position2 = (gl_FragCoord.xy / resolution.xy ) - mouse /2.9;
	float color = 0.0;
	float color2 = 0.0;
	color += tan( position.x * tan( time / 16.0 ) * 80.0 ) + tan( position.y * tan( time / 15.0 ) * 10.0 );
	color += tan( position.x * tan( time / 5.0 ) * 10.0 ) + tan( position.y * tan( time / 35.0 ) * 80.0 );
	color *= tan( time / 10.0 ) * 0.5;
	color2 += tan( position.x * tan( time / 16.0 ) * 80.0 ) + tan( position.y * tan( time / 15.0 ) * 10.0 );
	color2 += tan( position.x / tan( time / 5.0 ) * 10.0 ) + tan( position.y * tan( time / 35.0 ) * 80.0 );
	color2 *= tan( time / 10.0 ) * 0.5;
	if(color  > 0.4){
	gl_FragColor = vec4( vec3( color, color * 0.5, tan( color + time / 3.0 ) * 0.75 ), 1.0 );
	} else {
	gl_FragColor = vec4( vec3( color2, color2 * 0.5, tan( color2 + time / 7.0 ) * 0.75 ), 1.0 );
	}
	return gl_FragColor;
	
}
void main( void ) {
	calculateColor();
	
}