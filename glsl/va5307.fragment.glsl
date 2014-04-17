#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	position = vec2(length(position), atan(position.y / position.x));

	float time = time * time * 10.0;
	position.y += position.x;
	gl_FragColor = vec4(0.8, 0., 1., 1.) * sin(position.y*100. + time + position.x*time);
}