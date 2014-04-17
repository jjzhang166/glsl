#ifdef GL_ES
precision mediump float;
#endif
#define pi 3.14159265
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(vec2 p , vec2 o , float r ) {
	p-=o;
	return  step(length(p),r) ;
}

void main( void ) {

	vec2 p=gl_FragCoord.xy / resolution.y;
	p.x -= resolution.x / resolution.y*0.5 ;
	p.y -=0.5 ;
	vec3 color = vec3 (sin(time*2.),0.9,cos(time)-0.4);
	float c = 0. ;
	for(float i = 1. ; i<10. ;i++ ){
		c+=circle( p , vec2(cos(i*time/5.)/5.0,sin(i*time/5.)/5.0) , .05);
	}
	float d = circle(p , vec2(0.) ,0.1);	

	gl_FragColor = vec4( c*color+d*vec3(sin(time)-0.6,cos(time*3.),0.6), 01.0 );

}