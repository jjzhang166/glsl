#ifdef GL_ES
precision mediump float;
#endif

//Epilepsy by Frank R

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + 20. / 14.0 - mouse;
	

	float color = 0.0;
	color += tan(cos(sin( gl_FragCoord.xy + 1.))); //Make it rain
	//color += cos(mouse);
	color /= sin(time / 40.);
	color *= pow(time / 12., 0.9);
	color -= sin(position.x * cos(time / 10.0));
	color += sin( position.x * cos( time / 15.4 ) * 80.0 ) + cos( 5. * cos( time / 25.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.3 ) + cos( position.x * sin( time / 45.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.2 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 2.0 ) * 0.5;
	color += cos(time * 3.0) * 0.5;
	
	
	color /= sin(tan(cos(position.y))) * 3. - (3.14 * 5.);

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 * time );

}