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
	color *= mod(p.y, dot(p.x,p.y)*sign(p.x-p.y));
	color = smoothstep(50.0, 0.0, color);
	color = clamp(color, 0.0, 1.0);
	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}