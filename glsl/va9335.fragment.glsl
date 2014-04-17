#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.y *=10.0;
	position.y -=5.0;
	
	float color = 0.0;
	
	color=sin((sin(time)*1.0)+position.y*3.142*1.0)*10.0;
	float color2=-(abs(-sin(position.x*3.142*1.7+0.6))-position.y)*10.0;
	gl_FragColor = vec4( vec3( color, color2 , color2), 1.0 );

}