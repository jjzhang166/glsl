	
#ifdef GL_ES
precision mediump float;
#endif



uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14159265;

float toRadians(float degree){
	
	float angle = degree*PI/180.0;
	
	return angle;
	
}

float processColor(float init){
	
	float final;
	
	final = toRadians(init)/tan(time)/2.0;
	
	final*=0.01;
	
	return final;
}


void main( void ) {
	float rad = toRadians(gl_FragCoord.x);
	float rad2 = toRadians(gl_FragCoord.y);
	
	vec2 position = vec2(sin(rad2),cos(rad));
	
	float color = 0.0;
	color += sin(position.x)*time+resolution.x*0.005;
	color += cos(position.y)*time/resolution.y*0.005;
	
	color = processColor(color);
	
	gl_FragColor = vec4( vec3(sin(color/position.y)*time,tan(color),1.0), 1.0 );

}