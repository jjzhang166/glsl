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
	color *= sin( position.y * sin( t / 10.0 ) * 40.0 ) + cos( position.x * sin( t / 225.0 ) * 100.0 );
	color *= sin( position.x * sin( t / 5.0 ) * 10.0 ) + sin( position.y * sin( t / 35.0 ) * 80.0 );
	color -= sin( t / 100.0 );
	color /= 0.001;
	float c1 = smoothstep(0.0, color, -15.5);
	float c2 = smoothstep(color, 0.0, -500.5);
	float c3 = c1 + c2;
	gl_FragColor = vec4( vec3( c3, c3, c3 ), 1.0 );

}