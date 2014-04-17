#ifdef GL_ES
precision mediump float;
#endif

//by Olivier de Schaetzen

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 getNeighborColor(vec2 pos) {
	vec3 c = max(texture2D(backbuffer, (pos + vec2(-1,0))/resolution.xy).rgb,
		 max(texture2D(backbuffer, (pos + vec2(1,0))/resolution.xy).rgb,
		 max(texture2D(backbuffer, (pos + vec2(0,-1))/resolution.xy).rgb,
		 texture2D(backbuffer, (pos + vec2(0,1))/resolution.xy).rgb)));
	
	return c;
}

void main( void ) {
	vec2 pos = gl_FragCoord.xy;
	
	vec2 point = vec2((1.+sin(time))/2.,(1.+cos(time))/2.)/2. + vec2(0.25,0.25);
	
	//if (mod(time, 3.) < 3.) {
		if (distance(point.xy*resolution.xy, pos) <= 80.) {
			gl_FragColor = vec4(1,0,0,0);
		}
	//}
	else {
		gl_FragColor = vec4(getNeighborColor(pos)*0.995,0);
	}
}