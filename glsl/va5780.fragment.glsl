#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;



void main( void ) {
	vec4 lineColor, backColor;
	float lineX, lineY;
	
	lineColor = vec4(0,0,0,1);
	backColor = vec4(1,1,1,1);
	
	lineY = 10.0 * sin(gl_FragCoord.x / 20.0) + 210.0;

	//
	if (gl_FragCoord.y == lineY) {
		gl_FragColor = lineColor;
	} 
	else 
	{
		gl_FragColor = backColor;
	}	
	
}