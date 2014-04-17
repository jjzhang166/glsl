#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

void main( void ) {
	
	float col = 0.;
	float col2 = 0.;
	float col3 = 0.;
	
	//really light lines
	col += clamp(ceil(mod(gl_FragCoord.x, 5.0)) - 4.0, 0.0, 1.0) * 0.05;
	col += clamp(ceil(mod(gl_FragCoord.y, 5.0)) - 4.0, 0.0, 1.0) * 0.05;
	col = clamp(col, 0.0, 0.05);
	
	//light lines
	col2 += clamp(ceil(mod(gl_FragCoord.x, 15.0)) - 14.0, 0.0, 1.0) * 0.25;
	col2 += clamp(ceil(mod(gl_FragCoord.y, 15.0)) - 14.0, 0.0, 1.0) * 0.25;
	col2 = clamp(col2, 0.0, 0.25);
	
	//strong lines
	col3 += clamp(ceil(mod(gl_FragCoord.x, 30.0)) - 28.0, 0.0, 1.0);
	col3 += clamp(ceil(mod(gl_FragCoord.y, 30.0)) - 28.0, 0.0, 1.0);
	col3 = clamp(col3, 0.0, 1.0);
	

	gl_FragColor = vec4(col2 * .5, col, col3 + col2,1.0);
}