#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 resolution = vec2(1080.0, 1920.0);
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);

	float color = 1.0/( sin( uPos.y * 5.0  + time) - (uPos.x)*15.0 );
	color = sqrt(color)*(-uPos.y-0.15);
	
	gl_FragColor = vec4( vec3(color), 1.0 );

}