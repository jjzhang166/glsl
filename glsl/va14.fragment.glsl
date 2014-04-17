// by @mrdoob, Piers Haken

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform sampler2D texture;

float border = 1.0;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;

	if (length(p) > border) {
		gl_FragColor = vec4(p, 0., 0.);
	}
	else {

		float a = atan( p.y, p.x );
		float r = sqrt( dot( p, p ) );

		vec2 uv = mod (time * vec2 (0.05, 0.06) + vec2 (cos(a), sin(a)) * 2.0 * mouse / r, 1.0);
	
		float amount = sin( time * 0.5 ) * 0.01;

		vec4 color0 = texture2D( texture, uv );
		color0 += texture2D( backbuffer, uv + vec2( 0.0, - amount ) );
		color0 += texture2D( backbuffer, uv + vec2( 0.0, amount ) );
		color0 += texture2D( backbuffer, uv + vec2( amount, 0.0 ) );
		color0 += texture2D( backbuffer, uv + vec2( - amount, 0.0 ) );

		gl_FragColor = ( color0 / 8.0 ) + pow( 1.0 - r, 11.0 );
	}
}