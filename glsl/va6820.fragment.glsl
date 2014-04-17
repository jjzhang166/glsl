#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 texture(vec2 p)
{
p=mod(floor(p*1.),2.);	
float x=length(p);
x=x*(4./(x*x+x*x*x));
x=cos(x);
return vec3(x,x,x);	
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-0.5;
	vec3 col=vec3(0);
	float u=atan(pos.y,pos.x)*3.141;
	float v=1./length(pos);
	
	for (int a=1;a<50;a++)
		col+=7./(pow(float(a),.7))*texture(vec2((float(a)*1.*u)+time,float(a)*v+time));
	gl_FragColor = vec4( 0.23*vec3(1.,0.7,0)*col/pow(v,1.2), 1.0 );

}