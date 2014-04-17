#ifdef GL_ES
precision mediump float;
#endif

void main( void ) {
	gl_FragColor = vec4(vec3(abs(sin(vec2((gl_FragCoord.xy) * 1000.0).y / 2.0)) / 2.0), 1.0);
}