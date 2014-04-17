#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
float noise(vec2 p)
{
	
	return fract(sin((p.x+p.y*1e3)*1e-3) * 1e5);
}

float rifts(vec2 p)
{
float res=mod(cos(time+(p.x+p.y)*35.)*cos(p.y*10.+time)+p.x*50.,4.)-.0;		
	res+=noise(p*12345.);
	res=smoothstep(0.,4.,res);
	res=atan(res*2.)/1.14;
	res=pow(res,17.1);
	return res;

}
void main( void ) 
{

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p=surfacePosition;
	vec3 c=vec3(0);
	float u=time*0.0125+atan(p.y,p.x)*180./3.14159265*0.01;
	float v=1./length(p);
	c.x=rifts(vec2(u,v));
	c.y=c.x*0.35;
	gl_FragColor = vec4( (2.-pow(v,0.25))*c, 1.0 );

}