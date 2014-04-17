#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy ;
	vec3 color = vec3(0.2,1,0.7);
	vec2 center = vec2(0.5) ;
	float dist = distance(p,center);
	float colorA = dist+0.2*cos(time)*sin(time)-0.3 ;

	gl_FragColor = vec4( 1.0-colorA*color*25.0, 1.0 );

}