

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define radius 0.8



void main( void ) {

	float aspectRatio = resolution.x / resolution.y;
	vec2 position = 2.0 * ( ( gl_FragCoord.xy / resolution.xy ) - vec2( 0.5, 0.5 ) );
	position.x *= aspectRatio;
	vec2 m = vec2(sin(time), sin(time));
	
	vec2 c = m - vec2( 0.5, 0.5);
	float dis = distance(position * position, c * c) + 0.5;
	if( dis > radius ) {
		discard;
	}
	
	gl_FragColor = vec4(  1.0, 1.0, 1.0, 1.0 );

}