#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159

vec2 rotate(vec2 p,float d){
	return vec2(p.x*cos(d)-p.y*sin(d),
		    p.x*sin(d)+p.y*cos(d));
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color;
	pos.y*=2.;
	
	float z=0.25;
	if(pos.y<0.75){
		z=1.-pos.y;
	}
	pos.x-=0.5;
	
	pos.x/=z;
	pos.y/=z;
	
	//pos=rotate(pos,mouse.x*PI*2.);
	
	if(z<=0.25){
		color.r+=32.*sin(8.*PI*pos.x-32.*mouse.x);
		color.r+=(32.*cos(4.*PI*pos.y+PI));
	}
	else{
		color.rgb+=32.*sin(8.*PI*pos.x-32.*mouse.x);
		color.rgb+=32.*cos(8.*PI*pos.y+PI);	
	}
	
	gl_FragColor = vec4(color,1.);

}