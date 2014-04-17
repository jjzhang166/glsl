#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	
	vec4 color0 = vec4(1.0, 0.0, 0.0, 1.0);
	vec4 color1 = vec4(0.0, 0.0, 1.0, 1.0);
	
	// raidal gradient
	
	vec2 light = mouse.xy;
	float radius = max(resolution.x, resolution.y);
	gl_FragColor = mix(color0, color1, distance(gl_FragCoord.xy, light)/radius);
	
	// linear gradient
	//gl_FragColor = mix(color0, color1, dot(resolution.xy, gl_FragColor.xy)/dot(resolution.xy, resolution.xy));
	

}