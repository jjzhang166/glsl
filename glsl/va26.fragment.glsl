//by @mrdoob, @IndialanJones

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	float color = 0.0;
	color = sin( position.x * cos( time / 166.0 ) * 20.0 ) + cos( position.y * cos( time / 165.0 ) * 10.0 );
	color *= sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 225.0 ) * 100.0 );
	color *= sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color -= sin( time / 100.0 ) * 0.5;
	gl_FragColor = vec4( vec3( color * sin( time * 2.0), color * 0.5 /time/0.001, sin( color + time / 100.0 ) * 0.45 ), 1.0 );

}