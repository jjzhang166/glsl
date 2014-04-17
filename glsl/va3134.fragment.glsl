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
	const float max_iteration=15.0;
	
	float t = sin(time/0.4) * 0.8;
	
	//t = 0.47;
	
	for (float i=0.0;i<max_iteration;i++)
	{
		
		x = x*x - y*y + (t * (1.0*position.y))*4.0;
		y = 2.0 * x*y + (t * (-1.0*position.x))*4.0;
		
		if(x*x+y*y>=128.0) break;
		it=i;
	}
	
//	gl_FragColor=vec4(sin(it*132.4),sin(it*82.4),sin(it*145.4),1.0);
	
	float r = it/max_iteration;
	
//	if(r>0.5)r=1.0;
//	else r=0.0;
	
	gl_FragColor=vec4(r,r,r,1.0);
}