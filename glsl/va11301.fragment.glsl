#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 color(float r , float g , float b ){
	return vec3(r,g,b);
}

float circle(vec2 p , vec2 o ){
	p-=o;
	return length(p);
	
}


void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.y;
	p.x-= resolution.x / resolution.y*0.5;
	p.y-=0.5;
	

	
	float v = 1.0;
	
	float c = circle(p , vec2(cos(time*v)/5.0, sin(time*v)/5.0));
	c*= circle(p , vec2(cos(time*v/3.)/8.,sin(time*v/3.)/8.));
		
	gl_FragColor = vec4( (1.0-vec3( c*50. )*color(0.5,0.2,0.8))*50.0, 1.0 );

}