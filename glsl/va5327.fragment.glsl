#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float time = time * sin(time/100.0);
	
	float r = cos(time*position.y)*2.;
	position.y += (position.x + 1.0) * r;
	float g = sin(time*position.y)*2.;
	position.y *= sin((position.x + 1.0) * g);
	float b = tan(time*position.y)*2.;

	gl_FragColor = vec4( r, g, b, 1.) * atan(time);
}