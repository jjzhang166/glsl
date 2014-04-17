#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 mpos = mouse*resolution;
	
	float color1 = sin(distance(gl_FragCoord.xy,mpos)*+time*10.0);
	float color2 = sin(0.5*abs(gl_FragCoord.x-mpos.x)-time*10.0);
	float color3 = sin(distance(gl_FragCoord.xy,mpos)+time*10.0);
	
	vec4 color = vec4( color2,color2,color2, 1.0 );
	float distance1 = abs(mpos.x- gl_FragCoord.x);
	if (distance1 < 100.+50.*sin(time*5.)) {
		color *= clamp(distance1/80., 0.0, 1.0);	
	} else if (distance1 >= 100. && distance1 <= 170.) {
		color *= 1000.;	
	} else if (distance1 > 170. && distance1 <= 230.) {
		color *= clamp((distance1+170.)/1200., 0.0, 1.	);
	} else {
				color *= 0.0;
	}
	gl_FragColor = color;

}