#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	gl_FragColor = vec4(abs(sin(time)),abs(cos(time)),position.x*position.y,1) *
					 vec4(smoothstep(0.0, abs(sin(time*.2)*0.5), position.x+0.1) *
					      smoothstep(0.0, abs(cos(time*.5)*0.5), 1.1-position.x) *
					      smoothstep(0.0, abs(sin(time*.22)*0.5), position.y+0.1) *
					      smoothstep(0.0, abs(cos(time*.05)*0.5), 1.1-position.y));
}