#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 ratio=vec2(1.0,resolution.y/resolution.x);
float dist( vec2 p1, vec2 p2){

	return length((p1-p2)*ratio);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float colorr = 0.0;
	float colorg = 0.0;
	float colorb = 0.0;
	
	vec2 tmp1= vec2(sin(time/4.0)/2.0+0.5,cos(time/4.0)/2.0+0.5);
	vec2 tmp2= vec2(cos(-time)/2.0+0.5,sin(time)/3.0+0.5);
	vec2 tmp3= vec2(sin(time/2.0)/2.0+0.5,cos(time/2.0)/2.0+0.5);
	float dist1 = dist(position.xy, tmp1);
	float dist2 = dist(position.xy, tmp2);
	float dist3 = dist(position.xy, tmp3);
	if((dist1<0.01)||(dist2<0.01)||(dist3<0.01)||(dist1*dist2<0.01)||(dist2*dist3<0.01)|| (dist3*dist1<0.01)){
	 	colorr = 1.0;
	}
	
	gl_FragColor = vec4( vec3( colorr, colorr,colorr ), 1.0 );

	
}