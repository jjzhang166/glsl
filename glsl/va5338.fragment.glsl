#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n) { return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void main( void ) {

	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 - vec2(sin(time),-cos(time))*resolution.xy*0.25 ) / resolution.x;
	
	float angle = atan(position.y,position.x);
	angle = floor(angle/3.14159265359*128.);
	angle = fract(angle*fract(angle*.7235)*45.1);
	float rad = length(position);
	
	float color = 0.0;
	float t = time*21.0+20.0*sin(time)+angle*10.;
	for (int i = 0; i < 1; i++) {
		color += max(0.,sin(t+sqrt(angle)/rad)*100.-99.);
		angle = fract(angle+.61) + nrand(vec2(sin(time),sin(time*time)));
	}

	gl_FragColor = vec4( color )*0.55 + texture2D(backbuffer,gl_FragCoord.xy/resolution.xy)*0.75;
}