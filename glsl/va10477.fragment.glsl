// another way to draw circles, antialiased. Psonice

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void circle( float x, float y, float r, float t, float cr, float cg, float cb, float a) {
	/*float r = 0.1; // radius of circle
	float t = 0.001; // thickness of circle

	float cr = 0.2;
	float cg = 0.9;
	float cb = 0.1;
	float a = .20;*/

	vec2 position = ( ((gl_FragCoord.xy - resolution.xy*0.5) / resolution.x) );
	position.x += x;
	position.y += y;
	float l = length(position); // distance from centre
	float d = abs(l-r); // distance from circle
	d /= t; // d gets scaled to circle thickness
	
	float sr = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	float sg = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	float sb = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	float sa = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	
	sr = clamp(1.0-sr, 0.0, cr); // white on black, clamped to 0..1 range
	sg = clamp(1.0-sg, 0.0, cg); // white on black, clamped to 0..1 range
	sb = clamp(1.0-sb, 0.0, cb); // white on black, clamped to 0..1 range
	sa = clamp(1.0-a, 0.0, a); // white on black, clamped to 0..1 range
	
	gl_FragColor += vec4( sr, sg, sb, sa );
}

void main( void ) {
	
	/*float r = 0.1; // radius of circle
	float t = 0.001; // thickness of circle

	float cr = 0.2;
	float cg = 0.9;
	float cb = 0.1;
	float a = .20;

	vec2 position = ( ((gl_FragCoord.xy - resolution.xy*0.5) / resolution.x) );
	position.x += 0.2;
	position.y += 0.03;
	float l = length(position); // distance from centre
	float d = abs(l-r); // distance from circle
	d /= t; // d gets scaled to circle thickness
	
	float sr = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	float sg = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	float sb = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	
	sr = clamp(1.0-sr, 0.0, cr); // white on black, clamped to 0..1 range
	sg = clamp(1.0-sg, 0.0, cg); // white on black, clamped to 0..1 range
	sb = clamp(1.0-sb, 0.0, cb); // white on black, clamped to 0..1 range*/
	circle( 0.01, 0.02, 0.1, 0.003, 0.4, 0.4, 0.4, 0.2 );
	circle( 0.01, 0.02, 0.1, 0.001, 0.2, 0.9, 0.1, 1.0 );
	
	
	//gl_FragColor = vec4( sr, sg, sb, a );
	gl_FragColor.a = 0.2;

}