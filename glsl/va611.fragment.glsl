#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += sin( 10.0*position.x * (cos(0.5*time)+1.4) );
	color += sin( 10.0*position.y * (sin(time) + 2.1 ) );
	color += sin( 1.1 + distance(20.0*position, vec2(10.0+11.0*sin(time), 0.0+10.0*cos(time)) ));
	//color += 2.0*(1.0+sin( position.x*position.x + position.y*position.y));
	//color += 2.0*(1.0+sin( position.x*position.x - position.y*position.y));

	color += 3.0;

	gl_FragColor = vec4( vec3( color, color*sin(color+time*1.1314), color*sin(color+time*0.1))/(8.0), 1.0 );
	//gl_FragColor = vec4( vec3( color, cos(time)*color, sin(color*sin(time)))/(6.0), 1.0 );

}
