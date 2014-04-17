#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159

//messing around with projection

vec2 rotate(vec2 p,float d){
	return vec2(p.x*cos(d)-p.y*sin(d),
		    p.x*sin(d)+p.y*cos(d));
}

vec3 getColor(vec2 p){
	if(p.x>-0.25&&p.x<0.25){
		return vec3(0.25,0.25,0.25);
	}
	float f=0.;
	f+=32.*sin(PI*2.*p.x);
	f+=32.*sin(PI*2.*p.y);
	f/=1024.;
	f+=0.5;
	return vec3(0.,f,0.);
}

float getStripe(vec2 p){
	if(p.x>-0.025&&p.x<0.025){
		if(sign(sin(4.*p.y))==1.){
			return 1.;
		}
	}
	return 0.;
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	pos.x-=0.5;
	
	vec3 color;
	
	float z=1.-pos.y;
	//magical projection
	pos.x/=z;
	pos.y/=z;
	
	pos=rotate(pos,mouse.x*PI*2.);
	
	color+=getColor(pos+vec2(mouse.y*2.-1.,time));
	color+=getStripe(pos+vec2(mouse.y*2.-1.,time));
	
	gl_FragColor = vec4(color,0);

}