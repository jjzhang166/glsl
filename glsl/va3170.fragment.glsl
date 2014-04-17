//by @mrdoob, @IndialanJones
//mod ToBSn
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	float t = 8.;
	float color = 0.0;
	color = sin( position.x * cos( t / 166.0 ) * 20.0 ) + cos( position.y * cos( t / 165.0 ) * 10.0 );
	color *= sin( position.y * sin( t / 10.0 ) * 10.0 ) + cos( position.x * sin( t / 255.0 ) * 100.0 );
	color *= sin( position.x * sin( t / 5.0 ) * 10.0 ) + sin( position.y * sin( t / 105.0 ) * 120.0 );
	color -= sin( t / 100.0 ) * 0.8;
	color /= 0.01;
	color = smoothstep(color, 0.0, 25.5);
	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}