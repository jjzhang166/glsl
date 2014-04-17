#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float first = (sin(position.x * (time/15.0)) + cos(position.y * (time/15.0)));
	float secnd = (sin(position.y * (time/15.0)) + cos(position.x) * first);
	float third = (sin(position.y * (time/15.0)) + cos(position.x) * secnd * first);
	//float color = 0.0;
	//color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );

	gl_FragColor = vec4( sin(first) ,sin(secnd),sin(third),0.5 );

}