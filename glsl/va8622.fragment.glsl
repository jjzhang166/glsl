// simple mouse follow - nicer falloff

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
	gl_FragColor = vec4(smoothstep(1.0,0.0,distSquared*0.00001953125));
}