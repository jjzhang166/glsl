#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 centerImage=vec2(resolution.x/2.0,resolution.y/2.0);	
	float distance=sqrt(pow(centerImage.x-gl_FragCoord.x,2.0)+pow(centerImage.y-gl_FragCoord.y,2.0) );//Distance from Pixel to center;
	vec4 color=vec4(0.0,0.0,0.0,0.0);					
	color.x=distance/1000.0-( sin(time)/4.0);	
	gl_FragColor=color;
}