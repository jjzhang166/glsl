#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 1.0;
	
	color += sin(position.x*16.0+time/12.0)*0.5;
	color += cos(position.y*12.0+time) * 0.5;
	color += clamp(tan(position.x*position.y*time*1.0), 0.0, 1.0);
	color *= sin(time/20.0);
	

	gl_FragColor = vec4(sin(color*color), cos(color)+sin(color+time), color, 1.0 );

}