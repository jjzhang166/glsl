//stretching
//by @micgdev

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	if(p.y > sin(p.x + sin(time * 2.)) || p.y < sin(p.x - sin(time * 2.))) {
		discard;
	}	

	gl_FragColor = vec4(p.x);

}