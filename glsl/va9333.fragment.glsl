#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.y *= 10.0+sin(time);
	position.y -= 5.0;
	
	float color = 0.0;


	color = 1.0-abs(sin(time*2.0-position.x*3.142*1.0)-position.y)*1.0;
	float color2 = 1.0-abs(sin(time-position.x*3.142*1.0)-position.y-1.0)*1.0;
	float color3 = 1.0-abs(sin(time*3.0-position.x*3.142*1.0)-position.y+1.0)*1.0;
	
	gl_FragColor = vec4( vec3( color2, color , color3 ), 1.0 );

}