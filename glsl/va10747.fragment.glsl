#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415927

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float r = 0.007;
float speed = 0.5;
vec3 col =  vec3(0.5, 0.2, 0.2);
vec3 color ; 
vec2 center(float k) {
	vec2 cen = vec2(0.0);
	cen.x = fract(k * time);
	cen.y = 0.5;
	return cen;
}

void main( void ) {
	
	vec2 position =  gl_FragCoord.xy / resolution.x ;
	 
	float aspect = resolution.x / resolution.y;
	vec2 c = center(speed);
	c.y  /=  aspect;
	float d = distance(position , c);
	if( d < r) {
		color = col;
	}else if( d>=r && c.x > position.x && abs(position.y - c.y) < r){
		color  = col * ( max ( 0.8 - min ( pow ( d - r , 0.4 ) , 0.9 ) , -0.2 ) );
	}else{
		color = vec3(0.0);
	}	

	gl_FragColor = vec4( color , 1.0 );

}