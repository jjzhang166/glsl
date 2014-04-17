#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	// i was just typing random stuf and got this, pretty beautiful.

	vec2 position = ( gl_FragCoord.xy / resolution.xy);
	float radius = 0.5; // this isn't really radius
	float dX = radius - position.x;
	float dY = radius - position.y;
	float r = sqrt(dX * dX + dY * dY) / radius;
	
	
	r = pow(r, (sin(time * 0.2 * tan(dX)) + 1.0) * 0.5);
	
	r = smoothstep(0.0, 1.00, r);
	
	r = pow(r, 2.0);
	
	r *= asin(position.y + cos(position.x * position.y));
	
	
	gl_FragColor = vec4( r * 0.4, r * 0.7, r * 1.7 + 0.05, 1.0 );

}