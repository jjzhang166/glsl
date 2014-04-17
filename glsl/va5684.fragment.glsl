#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// shabby - visualising various interpolation curves
#define PI 3.1415926765
vec2 gPixSize;
vec2 gPos;

vec3 Plot(float f1,float f2,float width,vec3 col)
{
vec2 p1=vec2(gPos.x,f1);
vec2 p2=vec2(gPos.x+gPixSize.x,f2);
float res=distance(gPos,p2);
res=smoothstep(0.0,distance(p1,p2)*4.,res);
return col*(1.0-res);
}

float sinc(float x) {
	return sin(x)/(x);
}
float sincn(float x) {
	return sin(PI*x)/(PI*x);
}

void main( void ) 

{

	gPos = ( gl_FragCoord.xy / resolution.xy) * vec2(3.0,1.0) - vec2(1.,0.);
	gPixSize=4./resolution.xy;
	gPos=(gPos*4.0)-1.5;
	vec3 col = vec3(0.0);
	
	float f1=gPos.x;
	float f2=gPos.x+gPixSize.x;
	// Green Func - Linear
	col+=Plot(f1,f2,0.013,vec3(0.0,1.0,0.0));
	
	// Yellow Func - smoothstep
	f1=smoothstep(0.0,1.0,gPos.x);
	f2=smoothstep(0.0,1.0,gPos.x+gPixSize.x);
	col+=Plot(f1,f2,0.013,vec3(0.95,1.0,0.0));
	
	// red Func - cosine
	f1=(-cos(PI*gPos.x)*0.5)+0.5;
	f2=(-cos(PI*(gPos.x+gPixSize.x))*0.5)+0.5;
	col+=Plot(f1,f2,0.013,vec3(1.0,0.0,0.0));
	
	// White - cubic, offset coz is close to the others
	f1 = gPos.x*gPos.x*(3.0-2.0*gPos.x);	
	f2 = (gPos.x+gPixSize.x)*(gPos.x+gPixSize.x)*(3.0-2.0*(gPos.x+gPixSize.x));		
	col+=Plot(f1+0.025,f2+0.025,0.013,vec3(1.,1.0,1.0));
	// shabby grid affair
	col+=(mod(gPos.x,0.125))*vec3(1,1,1);
	col+=(mod(gPos.y,0.125))*vec3(1,1,1);
	
	f1 = sincn(gPos.x);
	f2 = sincn(gPos.x)+gPixSize.x;
	col+=Plot(f1,f2,0.02,vec3(1.0,0.0,1.0));
	
	gl_FragColor = vec4( col, 1.0 );

}