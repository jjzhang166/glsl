#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
mat4 roty(float a){
	float c = cos(a);
	float s = sin(a);
	return mat4(c,0,-s, 0,
		    0,1,0, 0,
		    s,0,c, 0,
		    0,0,0,1
		   );
}
mat4 perspective(float fovy,float a,float n,float f){
	float d = 1.0/tan(fovy/2.0);
	return mat4(d/a,0,0,0,
		    0,d,0,0,
		    0,0,(n+f)/(n-f),-1.0,
		    0,0,2.0*n*f/(n-f),0);
}

mat4 translation(float x, float y, float z){
	return mat4(1,0,0,0,
		    0,1,0,0,
		    0,0,1,0,
		    x,y,z,1);
}

float triArea(vec2 t1, vec2 t2, vec2 t3){
	return abs(0.5*(-t1.x*t2.y - t1.y*t3.x - t2.x*t3.y + t3.x*t2.y + t3.y*t1.x + t1.y*t2.x));
}

bool inTriangle(vec2 p, vec2 t1, vec2 t2, vec2 t3){
	return abs((triArea(t1,t2,p) + triArea(t1,p,t3) + triArea(p,t2,t3)) - triArea(t1,t2,t3)) < 0.000001;
}

vec2 transform(vec4 x){
	mat4 mv = translation(0.0,0.0,-2.0)*roty(time);
	mat4 proj = perspective(45.0, resolution.x/resolution.y, 0.1, 10.0);
	vec4 t = (proj*mv*x);
	return t.xy/t.w;
}

void main( void ) {
	vec2 p = ( 2.0 * gl_FragCoord.xy / resolution.xy) - vec2(1.0,1.0);
	vec2 m = ( mouse.xy *2.0 ) - vec2(1.0,1.0);
	float a = 0.50;
	vec4 t1 =  vec4(-a,-a,-0.0,1.0);
	vec4 t2 = vec4(a,-a,-0.0,1.0);
	vec4 t3 = vec4(0.0,a*1.5,-0.0,1.0);
	vec2 tt1 = transform(t1);
	vec2 tt2 = transform(t2);
	vec2 tt3 = transform(t3);
	if(inTriangle(p, tt1,tt2,tt3)){
		gl_FragColor = vec4( vec3( .2, .1, 0 ), 1.0 );
	}else{
		gl_FragColor = vec4( vec3( 0, 0, 0 ), 1.0 );
	}
}