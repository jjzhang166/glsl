#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 0.3;

	float color = 0.0;
	float channelA = sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	float channelB = sin( position.x * cos( time / 10.0 ) * 80.0 ) + cos( position.y * cos( time / 25.0 ) * 10.0 );
	float channelC = cos( position.x * cos( time / 3.0 ) * 20.0 )  + sin( position.y * sin( time / 55.0 ) * 10.0 );
	gl_FragColor = vec4(channelA+channelB, channelB * channelA, channelC*channelB, 0);
}