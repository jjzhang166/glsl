#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14;
float pi2 = 6.28;

void main( void ) {

	vec3 pos = vec3((2.*( gl_FragCoord.xy -resolution.xy*0.5 )/ resolution.y )+mouse , mouse / 4.0);

	
	float z_s=1.0; //screen z dist from eye
	
	//float color=pos.x;
	
	//float h = 0.5+0.5*sin(2.*3.14*pos.y);
	//float hpz = pos.y/z_s+0.1*sin(10.*pos.x)/z_s;

	//float z = asin(hpz);
	
	//float norm = hpz*z;
	
	//float h = 0.5+0.25*(sin(pos.x*pi*4.)+sin(pos.y*pi*4.))*1./(pos.x*pos.x+pos.y*pos.y);
	
	//float h = 1./(1.+pos.x*pos.x+pos.y*pos.y);
	//float norm=h;
	//float norm=0.5+0.25*(cos(pos.x*pi*4.)+cos(pos.y*pi*4.));
	
	//---
	//float hpz = 1./(pow(pos.y/z_s,2.),pow(pos.x/z_s,2.));
	
	//float z = pos.y/hpz;
	//float norm=z;
	//---
	float norm=0.;
	
	
	
	if(mod(10.*pos.x*(1.0+0.5*pos.y),1.)>0.95 || mod(10.*(pos.y + 0.05*sin(2.*pi*pos.x*(1.0+0.5*pos.y))),1.)>0.95)
	{
		norm=0.5;
	}
	
	gl_FragColor = vec4( vec3( norm, norm , norm), 1.0 );

}