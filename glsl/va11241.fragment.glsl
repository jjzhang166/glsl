#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy  ;

	float c = 0.0 ;
	float v = 0.0 ;
	
	c += cos(p.y*cos(time/10.0)*80.0)*sin(p.x*cos(time/20.0)*100.0) ;
	
	v+= cos(p.x*cos(time/10.0)*80.0)*sin(p.y*cos(time/20.0)*20.0) ;
	gl_FragColor = vec4( v+c,c*c,c-v,0 );

}