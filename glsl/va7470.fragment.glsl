#ifdef GL_ES
precision mediump float;
#endif
// spiralcity started by Snoep Games.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 position = ( 20.0*gl_FragCoord.xy - resolution) / resolution.xx;
	float t=time/300.0;
	float color = 1.0;
	float x=position.x+time;
	float y=position.y+time;
	float var=1.0;
	for(int n=0; n<=5; ++n)
	{
		var=var*0.990;
		float p=x;
		x=x+sin(y+time);
		y=y+cos(p-time)/var;
		if(atan(y*var,x/1.01)<atan(x,y/0.95))
		{
			color=0.0;
		}
		if(atan(y/2.0,x)>atan(x,y))
		{
			color=1.0;
		}
	}
	
	gl_FragColor.rgba = vec4(color,color,color, 1.0);

}