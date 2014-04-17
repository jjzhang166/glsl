#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / resolution;
	gl_FragColor = vec4(cos(mouse.y)*.5,cos(mouse.y)*.5,cos(mouse.y)*.5,1.);
	
	if(position.y < mouse.y){
		gl_FragColor = vec4(sin(mouse.y),sin(mouse.y),sin(mouse.y),1.);
	}
}