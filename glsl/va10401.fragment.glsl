#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 getNeighborColor(vec2 pos) {
	vec3 c = min(texture2D(backbuffer, pos + vec2(-1,0)).rgb,
		 min(texture2D(backbuffer, pos + vec2(1,0)).rgb,
		 min(texture2D(backbuffer, pos + vec2(0,-1)).rgb,
		 texture2D(backbuffer, pos + vec2(0,1)).rgb)));
	
	return c;
}

void main( void ) {
	vec2 pos = gl_FragCoord.xy;
	
	if (mod(time, 3.) < 0.25) {
		gl_FragColor = vec4(1,0,0,0);
	}
	else {
		gl_FragColor = vec4(getNeighborColor(pos),0);
	}
}