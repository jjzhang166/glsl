#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	
	
	gl_FragColor = vec4(fract(sin(position.x * sin(time * 0.15) * 15.0 +  time * 0.03) * cos(position.y * 2.0+  time * 1.0) + 
				  sin(position.x * sin(time * 0.05) * 20.0 +  time * 0.01) * cos(position.y * 12.0+  time * 4.0) + 1.0 + 
				  sin(position.x * 21.0 + time * 1.0) * cos(position.y * cos(time* 0.09) * 14.0 +  time * 5.0) + 1.0) , 0.0, 0.0, 0.0);

}