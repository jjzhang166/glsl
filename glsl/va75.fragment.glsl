// by @alteredq

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x/resolution.y;

	vec2 d1 = ( mouse - position ) * vec2( aspect, 1.0 );
	vec2 d2 = ( mouse + 0.1 * vec2( sin(time * 2.0), aspect * cos(time * 2.0) ) - position ) * vec2( aspect, 1.0 );
	vec2 d3 = ( mouse + 0.1 * vec2( sin(time * 3.0), aspect * sin(time * 2.0) ) - position ) * vec2( aspect, 1.0 );
	float c = 0.075 * abs(sin( 0.5 * time )) + 0.03;

	float dx = 3.0/resolution.x;
	float dy = dx * aspect;

	if ( length( d1 ) < c && length( d1 ) > 0.995 * c ) {

		gl_FragColor = vec4( 0.0, 0.0, 1.0, 1.0 );

	} else if ( length( d2 ) < c * 0.25 && length ( d2 ) > 0.24 * c ) {

		gl_FragColor = vec4( 0.0, 1.0, 1.0, 1.0 );

	} else if ( length( d3 ) < c * 0.25 && length ( d3 ) > 0.24 * c ) {

		gl_FragColor = vec4( 0.0, 0.5, 1.0, 1.0 );

	} else {

		vec4 v0 = texture2D( backbuffer, position );
		vec4 v1 = texture2D( backbuffer, position + vec2( 0.0, dy ) );
		vec4 v3 = texture2D( backbuffer, position + vec2( 0.0, -dy ) );

		float vv = 0.995 * v1.w;
		
		if ( v1.w > 0.0 ) gl_FragColor = vec4( 0.0, v1.g, vv, vv );

		if ( position.y < 1.0/resolution.y && v1.w > 0.1 ) gl_FragColor = vec4( 1.0, 0.0, 0.0, 0.0 );

		if ( v0.x > 0.0 ) gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
		if ( v3.x > 0.0 && v0.w > 0.0 ) gl_FragColor = vec4( 1.0 - position.y, v0.g, 0.0, 1.0 );

	}


}