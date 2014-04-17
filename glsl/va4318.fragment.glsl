#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x, float y, float fx, float fy, float sx, float sy, float t) {
	float xx = x+sin(t*fx)*sx;
	float yy = y+cos(t*fy)*sy;
	return 1.0/sqrt(xx*xx+yy*yy);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.x )*2.0-vec2(1.0,resolution.y/resolution.x);
	
	position = position*2.0;

	float x = position.x;
	float y = position.y;
	
	float a = 
		makePoint(x,y,3.3,2.9,0.3,0.9,time/2.0);
	a=a+makePoint(x,y,3.2,2.6,0.5,0.7,time);
	float b =
		makePoint(5.0,5.0,0.3,0.6,0.2,0.5,time);
	
	float c = 
		makePoint(10.0,10.0,0.6,0.6,0.1,0.1,time);
	
	vec3 d=vec3(a,b,c)/32.0;
	
	gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}