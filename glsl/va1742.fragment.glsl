#ifdef GL_ES
precision mediump float;
#endif

void main( void )
{
	float y = gl_FragCoord[0];
	gl_FragColor = vec4(sin(gl_FragCoord[1] * 0.05), cos(y*0.05), 0.0, 1.0);
}