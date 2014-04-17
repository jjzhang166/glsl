#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Cotton 

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;
	p *= 50.;
	p.x *= resolution.x/resolution.y;
	
	
	float color = 0.0;
	color += sin(p.x + sin(p.y));
	color *= mod(p.y + sqrt(p.x), cos(p.y));
	color = smoothstep(0.0, 0.1, color);
	color = clamp(color, 0.0, 1.0);
	gl_FragColor = vec4( color, color, color, 1.0 );

}