//by @mrdoob, @IndialanJones
//mod ToBSn

//bearing little resemblance to OG. - gtoledo
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ((gl_FragCoord.xy / resolution.xy)+5.);
	float t = 8.;
	//float color = 0.0;
	float color = sin( position.x * cos( t / 1.0 ) * 200.0 ) + cos( position.y * cos( t / 4.0 ) * sin(time*1.)+4. );
	color *= sin( position.y * sin( t / 4.0 ) * 250.0 ) + cos( position.x * sin( t / 6.0 ) * cos(time*2.)+1. );
	color *= sin( position.x * tan( t / 8.0 ) * 300.0 ) + sin( position.y * sin( t / 8.0 ) * (time+270.)/50.);
	color -= sin( t / 2.0 );
	color /= 0.09;
	float c1 = smoothstep(1.0, color, 5.);
	float c2 = smoothstep(color, 1.0, 20.);
	float c3 = c1 + c2;

	gl_FragColor = vec4( vec3( c1, c3, c2 ), 1.0 );

}