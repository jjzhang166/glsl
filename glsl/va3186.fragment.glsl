//by @mrdoob, @IndialanJones
//mod ToBSn

//bearing little resemblance to OG. - gtoledo
//2nd version...kinda like some morphing light bulbs-gt
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ((gl_FragCoord.xy / resolution.xy)+5.);
	float t = 8.;
	//float color = 0.0;
	float color = sin( position.x * cos( t / 3.0 ) * sin(time*.23)+200. );//+(time*.05)/50.;// + ( position.y * cos( t / 10.0 ) * sin(time*1.)+4. );
	color *= sin( position.y * sin( t / 8.0 ) * 200.0 )+cos(time)-1.;// + cos( position.x * sin( t / 8.0 ) * cos(time*2.)+50. );
	color *= sin( position.x * sin( t / 8.0 ) * 200.0 )+sin(time)+1.5;// - sin( position.y * sin( t / 2.0 ) * sin(time));
	color -= sin( t / 2.0 );
	color /= 0.04;
	float c1 = smoothstep(1.0, color, 7.);
	float c2 = smoothstep(color, 1.0, 50.);
	float c3 = c1 + c2;

	gl_FragColor = vec4( vec3( c3+.5, c3+.2, c3-.5 ), 1.0 );

}