#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	
	vec2 p = gl_FragCoord.xy / resolution.xy;
	float an = atan(p.y,p.x) ;
	float dy = 1.0/distance(p,vec2(0.5 ,0.5/an));
	
	gl_FragColor = vec4( cos(time*2.0+dy)+0.5,sin(time*5.0+dy)+0.5,sin(time*10.0+dy+5.0)+0.5,1.0 );
}