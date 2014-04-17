

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
	float dzik;
	if( dis > radius ) {
		dzik = smoothstep(dis, 1.0, sin(time));
	}
	float x;
	if( sin(time) >= 0.5 ) {
		x = 1.0 - position[0];
	}
	else {
		x = position[0];
			}
		
	gl_FragColor = vec4(  dzik, x, dzik / sin(dzik), 1.0 );
}