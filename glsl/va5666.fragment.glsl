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

// nice line dist render funk skagged from another shader - thx!
float segment(vec2 P, vec2 P0, vec2 P1)
{
	vec2 v = P1 - P0;
	vec2 w = P - P0;
	float b = dot(w,v) / dot(v,v);
	v *= clamp(b, 0.0, 1.0);
	return length(w-v);
}


vec3 Plot(float f1,float f2,float width,vec3 col)
{
vec2 p1=vec2(gPos.x,f1);
vec2 p2=vec2(gPos.x+gPixSize.x,f2);
float res=segment(gPos,p1,p2);
res=smoothstep(0.0,width,res);
return col*(1.0-res);
}



void main( void ) 

{

	gPos = ( gl_FragCoord.xy / resolution.xy);
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
	gl_FragColor = vec4( col, 1.0 );

}