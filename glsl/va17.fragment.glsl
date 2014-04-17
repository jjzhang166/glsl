//by @alteredq

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

	vec2 d = ( mouse - position ) * vec2( aspect, 1.0 );
	float c = 0.05 * abs(sin( 0.5 * time )) + 0.01;


	if ( length( d ) < c && length( d ) > 0.95 * c ) {

		gl_FragColor = vec4( vec3( 1.0, position.x, position.y ), 1.0 );

	} else {

		float dx = 1.0/resolution.x;
		float dy = dx * aspect;
		vec4 v0 = texture2D( backbuffer, position );
		vec4 v1 = texture2D( backbuffer, mod ( position + vec2( 0.0, dy ), 1.0 ) );
		vec4 v2 = texture2D( backbuffer, mod ( position + vec2( dx, 0.0 ), 1.0 ) );
		vec4 v3 = texture2D( backbuffer, mod ( position + vec2( 0.0, -dy ), 1.0 ) );
		vec4 v4 = texture2D( backbuffer, mod ( position + vec2( -dx, 0.0 ), 1.0 ) );
		vec4 v5 = texture2D( backbuffer, mod ( position + vec2( dx, dy ), 1.0 ) );
		vec4 v6 = texture2D( backbuffer, mod ( position + vec2( -dx, -dy ), 1.0 ) );
		vec4 v7 = texture2D( backbuffer, mod ( position + vec2( dx, -dy ), 1.0 ) );
		vec4 v8 = texture2D( backbuffer, mod ( position + vec2( -dx, dy ), 1.0 ) );

		vec4 s = v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8;

		// live cell

		if ( v0.w > 0.0 ) {

			if ( s.w < 2.0 || s.w > 3.0 )
				gl_FragColor = vec4( 0.0, 0.0, 0.0, 0.0 );
			else
				gl_FragColor = vec4( 1.0, position.x, 0.5, 1.0 );

		// dead cell

		} else {

			if ( s.w == 3.0 )
				gl_FragColor = vec4( 1.0, 0.5, position.y, 1.0 );
		}

	}

}