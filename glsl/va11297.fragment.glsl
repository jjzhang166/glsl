#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

//	vec2 center = vec2( sin( time ), cos( time ) );
	vec2 center = ( resolution.xy / 2.0 ) + (resolution.y / 2.0) * vec2( tan( time ), atan( time ) );
	
//	vec2 center = resolution.xy / 2.0;
	
	
//	vec2 center = vec2( 100.0, 10.0 );
	float dist = abs( distance( gl_FragCoord.xy, center ) ); 
//	vec3 color = vec3( sin( dist + time ), cos( dist + time ), tan( dist + time ) );
//	color += 20.0 * noise3( gl_FragCoord.x + time );
	vec3 color = vec3( sin( dist ), sin( dist ), sin( dist ) );
//	color += vec3( tan( time ) );
	color.r += tan( time );
	color.g += sin( time );
	color.b += cos( time );
	
	gl_FragColor = vec4( color, 1.0 );
	
}