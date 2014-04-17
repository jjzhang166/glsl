#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float r( vec2 co ) {
	return fract(tan(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453 + time);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;
	float color = r(position);
	gl_FragColor = vec4( color + tan(time), color - cos(time), color + tan(time), 1.0 );

}