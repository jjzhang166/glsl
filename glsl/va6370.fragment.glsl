#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float c = cos(time), s = sin(time);
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	vec2 prot = vec2(position.x * c + position.y * s, position.x * s - position.y * c);
	float pat = 1.0-40.0*mod(pow(prot.x, 0.6+0.5*(sin(prot.y*0.01*gl_FragCoord.y*gl_FragCoord.x+time)+1.0)), 1.0);
	gl_FragColor = vec4(0.0, pat, pat, 1.0 );

}