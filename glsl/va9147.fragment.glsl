//by retrotails
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float thickness = 8.0;
	float diff = 8.0;
	float color = 0.0;
	float k = resolution.y/32.0;
	if (gl_FragCoord.y >= sin(gl_FragCoord.x/k + time * 4.0)*k + resolution.y/2.0 - thickness/2.0) {
		if (gl_FragCoord.y <= sin(gl_FragCoord.x/k + time * 4.0)*k + resolution.y/2.0 + thickness/2.0) {
			if (cos(gl_FragCoord.y) >= tan(gl_FragCoord.x/64.0 + time*8.0)) {
				color = cos(time)/2.0 + 1.0;
			} else {
				color = sin(time);	
			}
		}
	}
	gl_FragColor = vec4(color*(sin(gl_FragCoord.y/8.0 + time*8.0)), color/sin(gl_FragCoord.x/64.0), color/2.0, 1.0 );
}