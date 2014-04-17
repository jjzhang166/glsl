//The slicing curves
//by @micgdev

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) + mouse;

	float s = sin(p.y);

	gl_FragColor = vec4( vec3( s, s * 0.5, sin( s + time / 3.0 ) * 0.75 ), 1.0 );
	
	if(cos(p.x + time) > sin(s - time)) {
		discard;
	}

}