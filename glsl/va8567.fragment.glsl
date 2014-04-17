// simple mouse follow

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 col = vec3(0.0, 0.0, 0.0);
	float size = 20.0;
	vec2 pointerPos = vec2(floor(mouse.x*resolution.x)+0.5, floor(mouse.y*resolution.y)+0.5);
	
	vec2 pos = pointerPos - gl_FragCoord.xy;
	float distSquared = dot(pos, pos);
	
	gl_FragColor = mix(vec4(1.0), vec4(col, 1.0), smoothstep(600.0, 800.0, distSquared));
	

	
}