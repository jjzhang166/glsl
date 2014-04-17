#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 colour;	
	if(sin(gl_FragCoord.x) >= sin(time)){
		colour.r = 0.0;
	} else if(sin(gl_FragCoord.y) >= sin(time)){
		colour.g = 0.2;
	}
	gl_FragColor = vec4(colour,1);
}