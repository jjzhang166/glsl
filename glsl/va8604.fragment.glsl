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
	if(distSquared > 100.0) {
		gl_FragColor = vec4(0.0);
	} else {
		gl_FragColor = vec4(1.0);
	}
}