#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 npos = ( gl_FragCoord.xy / resolution.xy ) ;
	
	
	float gray = sin(length(npos-mouse));
	vec3 color = vec3(gray,gray,gray);
	
	gl_FragColor = vec4(color, 1);
}