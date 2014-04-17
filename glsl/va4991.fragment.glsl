#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = sin(position.x * 10.0 + time) + cos(position.y * 10.0 + time) * length(position);
	float green = cos(position.x * 23.0 + sin(time)) + sin(position.y * 10.0 + sin(time));
	float blue = 10.0 * sin(time * 1.0) * cos(position.x) * position.y * position.x;
	blue += tan(position.x*(cos(position.y+(time/10.0))*0.5) * 50.0) + tan(position.y*(sin(exp(position.x)+sin(time/ 13.0))*0.5) * 33.0);
	
	gl_FragColor = vec4(green+color, blue+green, blue+color,1.0); //vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}