#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 col;
float gY;
float gX;

vec2 noise(vec2 n) {
	vec2 ret;
	ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453)*2.0-1.0;
	ret.y=fract(sin(dot(n.xy, vec2(34.9865, 65.946)))* 28618.3756)*2.0-1.0;
	return normalize(ret);
}

float perlin(vec2 p) {
	vec2 q=floor(p);
	vec2 r=fract(p);
	float s=dot(noise(q),p-q);
	float t=dot(noise(vec2(q.x+1.0,q.y)),p-vec2(q.x+1.0,q.y));
	float u=dot(noise(vec2(q.x,q.y+1.0)),p-vec2(q.x,q.y+1.0));
	float v=dot(noise(vec2(q.x+1.0,q.y+1.0)),p-vec2(q.x+1.0,q.y+1.0));
	float Sx=3.0*(r.x*r.x)-2.0*(r.x*r.x*r.x);
	float a=s+Sx*(t-s);
	float b=u+Sx*(v-u);
	float Sy=3.0*(r.y*r.y)-2.0*(r.y*r.y*r.y);
	return a+Sy*(b-a);
}

float fbm(vec2 p) {
	float tme=time*0.1;
	float f=0.0;
	vec2 p1=vec2(p.x+cos(tme+p.y*.25),p.y+sin(tme+p.x*.25));
	f+=perlin(p1);
	f+=perlin(p1*2.0+time*sin(time*0.01))*0.5;
	f+=perlin(p1*4.0)*0.25;
	f+=perlin(p1*8.0)*0.125;
	f+=perlin(p1*16.0)*0.0625;
	return f/1.0;
}

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
	col+=PlotFunc(fbm(position.xx-time),vec3(1,0,0),0.0125);
	col+=PlotFunc(fbm(position.xx-time*1.5)*1.5,vec3(0,1,0),0.0125);	
	col+=PlotFunc(fbm(position.xx-time*2.0)*0.5,vec3(0,0,1),0.0125);		
//	col+=PlotFunc(acos(gX*8.0),vec3(1,1,0),0.0125);			
//	col+=PlotFunc(tan(gX*8.0),vec3(1,0,1),0.0125);	
	
	gl_FragColor = vec4( col, 1.0 );

}