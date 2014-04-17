#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
varying vec2 surfacePosition;

void main( void ) {

	vec2 position = surfacePosition * 2.0;
	float x,x0,y,y0;
	x=x0=position.x;
	y=y0=position.y;
	float it=0.05;
	const float max_iteration=100.0;
	
	for (float i=0.0;i<max_iteration;i++)
	{
		//x+=y*y-0.9;
		//y+=x*x-0.001;
		x+=y*y*x-0.3;
		y+=x*x*y-0.4;
		x=x-y*0.2;
		y=y+x*0.9;
		
		if(x*x+y*y>=4.0*4.0) break;
		it=i;
	}
	
	gl_FragColor=vec4(sin(it*132.4),sin(it*82.4),sin(it*145.4),1.0);

}