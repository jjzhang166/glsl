//  I don't know who did the original, but here it is, with a little more motion.
//  modded by @dennishjorth

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
	//position.x*=resolution.x/resolution.y;
	position*=surfaceSize;
	position+=surfacePosition;
	
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
		x=x-cos(3.14*sin(y*0.2+time*0.1)+time*.01)*y*0.7;
		y=y+sin(3.14*cos(x*0.9+time*0.1)+time*.01)*x*0.7;
		
		
		
		
		if(x*x+y*y>16.0) break;
		it=i;
	}
	
	
	gl_FragColor=vec4(sin(it*32.4),sin(it*32.4),sin(it*16.4)+1.0,1.0);

}