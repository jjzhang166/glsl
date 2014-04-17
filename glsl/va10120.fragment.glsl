#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 8.0;
	float color = 0.0;
	
	color += sin(position.x * cos(time / 12.0) * 20.0) + cos(position.y * sin(time / 2.0) * 4.0);
	color += cos(position.y * sin(time / 8.0)  * 5.0) + sin(position.x * cos(time / 5.0) * 8.0);
	color += sin(position.y * cos(time / 4.0)  * 2.0) + cos(position.x * cos(time / 20.0) * 12.0);
	color *=  -0.5 + smoothstep(time * 0.75, time * 0.05, cos(time) * 0.023) + 0.5;
	
	
	gl_FragColor = vec4(smoothstep(cos(color), sin(time / 2.0), 0.1), sin(color * cos(time/1.0)), smoothstep(color / 1.0, time / 1.0, 0.5), 1.0);

}