#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float order = 4.;
	float freq = -position.x*-position.y;
	float num = tan(sin(dot(time/(position.y-freq), time*(position.x-freq))+(position.x-freq)*-(position.y-freq)*time))*fract((position.x-freq)/(position.y-freq)*2222.+mod(time, 20.2354+sin(position.y)));
	vec3 rgb = texture2D(backbuffer, position.xy).rgb;
	gl_FragColor = vec4( 1.1*rgb+vec3(num), 1.0 );

}