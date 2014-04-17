#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 col;
float gY;
float gX;

vec3 PlotFunc(float res,vec3 col,float width)
{
	vec3 rcol=vec3(0.0);
	if (length(vec2(gX,gY)-vec2(gX,res))<=width) rcol=col;
	return rcol;
	
}
void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy )-0.5)*5.0;
	gX=position.x;
	gY=position.y;
	
	float color = 0.0;
	vec3 col=vec3(0,0,0);
	// Plot Grid
	for (float o=-3.0;o<3.0;o+=0.5)
		{
		col+=PlotFunc(0.0+o,vec3(0.2,0.2,0.2),0.0025);					
		col+=PlotFunc(gY+gX+o,vec3(0.2,0.2,0.2),0.0025);						
		}
	
	// Plot Funk
	col+=PlotFunc(cos(time+gX*8.0),vec3(1,0,0),0.0125);
	col+=PlotFunc(sin(time+gX*8.0),vec3(0,1,0),0.0125);	
	col+=PlotFunc(asin(gX*8.0),vec3(0,0,1),0.0125);		
	col+=PlotFunc(acos(gX*8.0),vec3(1,1,0),0.0125);			
	col+=PlotFunc(atan(gX*8.0),vec3(1,0,1),0.0125);	
	
	gl_FragColor = vec4( col, 1.0 );

}