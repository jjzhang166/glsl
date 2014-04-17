#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float color = 0.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	//color += position.x - position.y;
	color +=  (position.x*2.0/position.y*0.5)*0.05;
	color += sin(time / 5.0)*10.0*position.x;
	color += cos(time / 5.0)*10.0*position.y;
	
	
	gl_FragColor = vec4(0.0,sin(time) * 3.0,sin(time),0.5) * color;

}