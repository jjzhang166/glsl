#ifdef GL_ES
	precision mediump float;
#endif
void main() {
	float red = sin(gl_FragCoord.x/50.0);
	float green = sin(gl_FragCoord.y/45.0);
	red = ((red/2.0)+0.5) * 0.5;
	green = ((green/2.0)+0.5) * 0.5;
	
	gl_FragColor = vec4(red,green,0,1);
}