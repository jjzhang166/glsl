#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float color = 1.0;
	color = gl_FragCoord.x/resolution.x;
	vec2 center = resolution * 0.5;
	center = center - gl_FragCoord.xy;
	if(length(center) < 100.0){
		color = 1.0;
	}

	gl_FragColor = vec4(color);

}