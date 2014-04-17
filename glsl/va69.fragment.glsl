#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x / resolution.y;

	float dx = 1.0 / resolution.x;
	float dy = dx * aspect;
	vec2 p = position - 0.5;

	if ( length(p.xy) < 0.005 ) {

		float rand = mod( fract( sin( dot( position + time, vec2( 12.9898, 78.233 ) ) ) * 43758.5453 ), 1.0 );
		rand = pow( rand, 2.0 ) * 2.0;
		gl_FragColor = vec4( rand, ( rand - 1.5 ) * 20.0, 0.0, 1.0 );

	} else {
		float a = 5.0*sin(time), r = 9.0, c = r * cos(a), s = r * sin(a);
		vec4 color0 = texture2D( backbuffer, position );
		vec4 color1 = texture2D( backbuffer, position + vec2( c * dx - s * dy,  c * dx + s * dy) );
		vec4 color2 = texture2D( backbuffer, position + vec2(-c * dx + s * dy, -c * dx - s * dy) );

		gl_FragColor = ( sin( color1 - 1.1 * color2 + color1 * color0 * 1.0) + 0.01 ) / (1.0 + 0.2 * length(p.xy));
	}

}