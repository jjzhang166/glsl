#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// shabby - visualising various OSC with filter simulation

#define PI 3.1415926765
vec2 gPixSize;
vec2 gPos;

vec3 Plot(float f1,float f2,float width,vec3 col)
{
vec2 p1=vec2(gPos.x,f1);
vec2 p2=vec2(gPos.x+gPixSize.x,f2);
float res=distance(gPos,p2);
res=smoothstep(0.0,distance(p1,p2)*width,res);
return col*(1.0-res);
}

float sinc(float x)  {	return sin(x)/(x);}
float sincn(float x) {	return sin(PI*x)/(PI*x);}

// much much better version - should sound totally awesome :P
float PhaseDistortion(float x)
{
x=x*0.2;
// ugh - this needs total remapping!	
float d=1.+abs(cos(time)*2.);	
d=pow(d,3.);
float	  halfwayPhase = 0.5 / d; 
float    speedDown = 0.5 /(1.- halfwayPhase); 
float phase=mod(x,1.);	
 if(phase < halfwayPhase) 
    { 
        return -cos(2.0 * PI * phase * d); 
    } 
    else 
    { 
        return -cos(2.0 * PI * ((phase - halfwayPhase) * speedDown + 0.5)); 
    } 
}
void main( void ) 

{

	gPos = ( gl_FragCoord.xy / resolution.xy) * vec2(3.0,1.0) - vec2(1.,0.);
	gPixSize=4./resolution.xy;
	gPos=(gPos*4.0)-1.5;
	vec3 col = vec3(0.0);
	
	float f1=PhaseDistortion(gPos.x);
	float f2=PhaseDistortion(gPos.x+gPixSize.x);
	// Green Func - ADSR1
	col+=Plot(f1,f2,8.,vec3(1.0,0.7,0.0));
	
	// shabby grid affair
	col+=(mod(gPos.x,0.125))*vec3(1,1,1);
	col+=(mod(gPos.y,0.125))*vec3(1,1,1);
	
	
	gl_FragColor = vec4( col, 1.0 );

}