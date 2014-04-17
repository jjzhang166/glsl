#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 vPos=gl_FragCoord.xy/resolution.xy;
	
	gl_FragColor = vec4(sin(vPos.x*time),sin(vPos.y*time),0,1);
}