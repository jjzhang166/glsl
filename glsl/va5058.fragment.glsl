#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 p = - 1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
	p.x *= resolution.x/resolution.y;
	vec3 col = vec3(0.0);
	
	
	float tau = 6.28;
	float r = length(p);
	float t = time;
	
	r += sqrt(dot(p, vec2(sin(t + tau), cos(t + tau))));
	r += sqrt(dot(p + vec2(.12,0.0), vec2(sin(t + tau/3.0), cos(t + tau/3.0))));
	r += sqrt(dot(p - vec2(.12,0.0), vec2(sin(t + tau/3.0*2.0), cos(t + tau/3.0*2.0))));
	
	col = vec3((1.0- r));
	
	//col = mix(col, texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb, 0.98);
	gl_FragColor = vec4( col, 1.0 );

}