#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// by wststreet
// www.kamehamehaaa.org
// wststreet2@gmail.com

float line(float x){
	return -0.01*sin(30.0*x+time*2.0)+
		0.02*sin(10.0*x+time*1.0)+
		-0.03*sin(3.0*x+time*0.5)+0.5;	
}

float hdist(float x, float y){
	return (y-x)>0.0?y-x:x-y;
}
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec4 color ;
	
	float lineposx = line(position.x);
	
	if(position.y < lineposx-0.003){
		color=vec4(0.0,0.3,0.5,1.0);
	}
	else if (position.y > lineposx+0.003){
		color=vec4(0.0,0.7,1.0,1.0);
	}
	else{
		color=vec4(0.3,0.7,0.1,1.0)/abs(200.0*(position.y-lineposx));
	}
	float t_color = hdist(position.y,line(position.x));
	color -= vec4(t_color, t_color, t_color, t_color);
	
	gl_FragColor = color;

}

