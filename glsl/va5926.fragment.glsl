//MG  //Blur effect - I feel ever so confident that this is NOT the best way to do this
//  1.0/(e^(x/1.3)^2.0)  //5.24
//  0.01  0.05  0.09  0.05  0.01
//  0.05  0.31  0.55  0.31  0.05
//  0.09  0.55  1.00  0.55  0.09
//  0.05  0.31  0.55  0.31  0.05
//  0.01  0.05  0.09  0.05  0.01
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec4 sinewave(vec2);

void main() {
	vec2 q=gl_FragCoord.xy;
	vec4 col;
	
	col=sinewave(vec2(q.x-2.0,q.y+2.0))*0.01;
	col+=sinewave(vec2(q.x-2.0,q.y+1.0))*0.05;
	col+=sinewave(vec2(q.x-2.0,q.y))*0.9;
	col+=sinewave(vec2(q.x-2.0,q.y-1.0))*0.05;
	col+=sinewave(vec2(q.x-2.0,q.y-2.0))*0.01;
	
	col+=sinewave(vec2(q.x-1.0,q.y+2.0))*0.05;
	col+=sinewave(vec2(q.x-1.0,q.y+1.0))*0.31;
	col+=sinewave(vec2(q.x-1.0,q.y))*0.55;
	col+=sinewave(vec2(q.x-1.0,q.y-1.0))*0.31;
	col+=sinewave(vec2(q.x-1.0,q.y-2.0))*0.05;
	
	col+=sinewave(vec2(q.x,q.y+2.0))*0.09;
	col+=sinewave(vec2(q.x,q.y+1.0))*0.55;
	col+=sinewave(vec2(q.x,q.y))*1.00;
	col+=sinewave(vec2(q.x,q.y-1.0))*0.55;
	col+=sinewave(vec2(q.x,q.y-2.0))*0.09;
	
	col+=sinewave(vec2(q.x+1.0,q.y+2.0))*0.05;
	col+=sinewave(vec2(q.x+1.0,q.y+1.0))*0.31;
	col+=sinewave(vec2(q.x+1.0,q.y))*0.55;
	col+=sinewave(vec2(q.x+1.0,q.y-1.0))*0.31;
	col+=sinewave(vec2(q.x+1.0,q.y-2.0))*0.05;
	
	col+=sinewave(vec2(q.x+2.0,q.y+2.0))*0.01;
	col+=sinewave(vec2(q.x+2.0,q.y+1.0))*0.05;
	col+=sinewave(vec2(q.x+2.0,q.y))*0.9;
	col+=sinewave(vec2(q.x+2.0,q.y-1.0))*0.05;
	col+=sinewave(vec2(q.x+2.0,q.y-2.0))*0.01;
	
	col=col/5.24;
	
	gl_FragColor=vec4(vec3(col),1.0);
}

vec4 sinewave(vec2 p) {
	p=(p.xy/resolution.y)*10.0;
	p.x-=resolution.x/resolution.y*5.0;p.y-=5.0;
	float f=sin(p.x+time*0.2)+p.y;
	if (abs(f)<0.5) {return vec4(1.0,1.0,1.0,1.0);}
	return vec4(0.0625,0.125,0.25,1.0);
}