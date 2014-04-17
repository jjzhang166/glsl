#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 2.0;

	float color = 0.2;
	color += sqrt( pow((resolution.x/2.0-gl_FragCoord.x), 2.0) + pow((resolution.y/2.0-gl_FragCoord.y), 2.0));
	color += sin(time*0.75)*(resolution.x+resolution.y)/4.0;

	gl_FragColor = vec4( color, color, color, 1.0 );

}