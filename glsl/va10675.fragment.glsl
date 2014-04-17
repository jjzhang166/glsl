#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 corner = vec2(1.0 * cos(time) - 1.0 * sin(time), 1.0 * sin(time) + 1.0 * cos(time));
	
	corner *= 0.5;
	
	corner += 0.5;
	
	//corner.x = clamp(corner.x, 0.0, 1.0);
	//corner.y = clamp(corner.y, 0.0, 1.0);

	float color = distance(position, corner);
	//float color = length(corner);
	
	//color *= position.x * cos(time) - position.y * sin(time);
	//color *= position.x * sin(time) + position.y * cos(time);
/*	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;*/
	

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}