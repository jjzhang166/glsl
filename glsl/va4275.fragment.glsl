// domain warping on noise. about : http://www.iquilezles.org/www/articles/warp/warp.htm
// hftom: removed neglictable extra noise and added wavy anim.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.9 );

float hash( float n ) {
    return fract(sin(n) * 9.0);
}

float noise( in vec2 x ) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f *= f*(3.0 - 2.0 * f);
    float n = p.x + p.y * 7919.0;
    return mix(mix( hash(n), hash(n + 1.0), f.x), mix( hash(n + 7919.0), hash(n + 7920.0),f.x),f.y);
}

float fbm( vec2 p ) {
    return (0.25 * noise( p * 3. )) / .38;
}

void main( void ) {
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x / resolution.y;

        vec2 dx1 = vec2(1.0, 1.0);	
	vec2 dy1 = vec2(1.2, 1.3);
	
	vec2 dx2 = vec2(1.6, 1.3);
	vec2 dy2 = vec2(1.2, 1.6);

	//dx1 *= mat2(time/5.);
	dx1 = dx1 * mat2(cos(time / 5.33), -sin(time / 2.66), -sin(time / 2.33), cos(time / 3.33));
	
	vec2 q = vec2(fbm( p + dx1 ), fbm( p + dy1 ) );
	vec2 s = vec2( fbm( p + 3.5 * q + dx1 + dx2 ), fbm( p + 3.5 * q + dy1 + dy2 ) );
		
	float v = fbm( p + 5. * s );
	vec3 col = 2.0 * v * vec3(q.x + s.y, q.y * s.x, s.x - s.y) + vec3(s.x + q.y, s.y * q.x, q.x - q.y);
	col = col * 0.4;
	gl_FragColor = vec4( col, 1. );
}