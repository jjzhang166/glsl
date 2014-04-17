#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p.x *= (resolution.x/resolution.y);
	vec2 m = vec2(mouse.x * (resolution.x/resolution.y), mouse.y);
	float dist = sqrt(((p.x - m.x)*(p.x - m.x)) + ((p.y - m.y)*(p.y - m.y)));
	
	float sph = -0.4;
	sph += max(length(p - m), 0.47);
	sph /= length(p - vec2(1.0, 0.5));
	gl_FragColor = vec4(1,1,1,1)*sph;

}