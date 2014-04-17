#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



//uniform vec2 pos
vec2 pos = vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y);
float ratio = resolution.x/resolution.y;


vec2 circle(vec2 m, float r) {
	return vec2(0.0,0.0);
}

vec2 rep( vec2 p, vec2 c )
{
    return mod(p,c)-0.5*c;
}

float cirlcedist(vec2 p, vec2 circlem, float circler) {
	return distance(p, circlem)-circler;
} 

vec2 myrep(vec2 p, vec2 c) {
	return mod(p,c);
}

void main (void) {
	
	//vec2 p = vec2(0.5,0.5);
	float r=0.0;
	//float g=sin(time)*0.5+0.5;
	float g=0.2;
	float b=0.2;
	float pi = 3.14;
	
	//draw a circle
	vec2 circlem = vec2(0.05, 0.05);
	vec2 circlem2 = vec2(0.03, 0.03);
	//circlem.x=sin(time)*0.5+0.5;
	//circlem.y=(cos(-time)*0.5+0.5)/ratio;
	//float circler = (sin(time*6.)*0.5+0.5)*0.05;
	float circler = 0.01;
	
	pos = myrep(pos,vec2(0.1,0.1));
	float d1 = cirlcedist(pos,circlem, circler);
	float d2 = cirlcedist(pos,circlem2, circler);
	float d = min(d1,d2);
	//d = d1/d2;
	//if (distance(circlem,vec2(pos.x,pos.y/ratio)) < circler) {
	if (d<0.) {
		g = 0.8;
		//g = sin(time*13.)*0.5+0.5;
	}
	
	/*
	////p.x) {
	if (pos.x < sin(time)*0.5+0.5){
		r=1.2;
	} else {
		r=0.2;
	}
	
	if (pos.y < sin(time)*0.5+0.5){
		b=1.2;
	} else {
		b=0.2;
	}
	//*/
	gl_FragColor = vec4(vec3(r,g,b),1.0);
}
