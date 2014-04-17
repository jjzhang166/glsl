#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )-0.5;
	position.x*=resolution.x/resolution.y;
	position*=surfaceSize;
	position+=surfacePosition;
	
	float x,x0,y,y0;
	x=x0=position.x;
	y=y0=position.y;
	float it=0.05;
	const float max_iteration=100.0;
	
	for (float i=0.0;i<max_iteration;i++)
	{
		
		x+=y*y-0.67;
		y+=x*x-0.09;
		if(x*x+y*y>=6.0) break;
		it=i;
	}
	
	
	gl_FragColor=vec4(sin(it*322.4),sin(it*812.4),sin(it*1245.4),1.0);

}