#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy - mouse + (.5,.5));

	float color = 0.0;
	float f = sin(p.x*11.*6.28) - p.y*10. + 5.;
	
	color = 1./(f*f*1000.); 
	

	gl_FragColor = vec4( vec3( color, color, color) , 1.0 );

}