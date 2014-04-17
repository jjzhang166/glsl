/*****************\
| 		  |
| Syria Freedom   |
|		  |
\*****************/


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159

float rotate(vec2 p,float angle){
   return p.x*cos(angle)-p.y*sin(angle);
}

float rect(vec2 p, vec2 s ){
	vec2 dist = abs(p)-s;
	return step(dist.x,0.)*step(dist.y,0.);
}

float star(vec2 p,float r) {
	float p0 = rotate(p, radians(54.0));
	float p1 = rotate(p, radians(126.0));
	float p2 = rotate(p, radians(198.0));
	float p3 = rotate(p, radians(270.0));
	float p4 = rotate(p, radians(342.0));
	
	float j = step(r,p0)+step(r,p1)+step(r,p2)+step(r,p3)+step(r,p4);
	return step(j,1.5);
}

void main( void ) {
	// wave
	vec2 pos = ( gl_FragCoord.xy / resolution.y );
	float waveAmount = exp(mouse.x*4.);
	pos += sin((pos.yx-.5)*3.*waveAmount+time)*.1/waveAmount;
	
	// background
	vec3 col = vec3(0.6,0.6,.8);

	// green top
	float green = rect(pos-vec2(0.0,0.83),vec2(1.6,0.14));
	col = mix(col,vec3(0,0.5,0),green);
	
	// white middle
	float white = rect(pos-vec2(0.0,0.55),vec2(1.6,0.14));
	col = mix(col,vec3(1,1,1),white);
	
	// black bot
	float black = rect(pos-vec2(0.0,0.27),vec2(1.6,0.14));
	col = mix(col,vec3(0,0,0),black);
	
	// three red stars
	float red = star(pos-vec2(0.25,0.55),0.03);
	red += star(pos-vec2(0.67,0.55),0.03);
	red += star(pos-vec2(1.1,0.55),0.03);
	col = mix(col,vec3(1,0,0),red);
	
	gl_FragColor = vec4(col, 1.0);

}