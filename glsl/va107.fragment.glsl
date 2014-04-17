#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float color_r = 0.0;
	float color_g = 0.0;
	float color_b = 0.0;
       	color_r = ((1.0+sin(gl_FragCoord.x*0.2*cos(time*0.1)))/2.0)+((1.0+sin(gl_FragCoord.y*0.2*cos(time*0.1)))/2.0);
	
       	color_g = ((1.0+sin(0.2+gl_FragCoord.x*0.1*cos(time*0.1)))/2.0)+((1.0+sin(gl_FragCoord.y*0.1*cos(time*0.1)))/2.0);
	
	color_b = ((1.0+sin(0.1+gl_FragCoord.x*0.1*cos(time*0.15)))/2.0)+((1.0+sin(gl_FragCoord.y*0.1*cos(time*0.1)))/2.0);

	gl_FragColor = vec4(color_r, color_g, color_b, 1.0);	

}