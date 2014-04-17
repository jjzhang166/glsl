#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 position = (gl_FragCoord.xy-resolution.xy/2.0) / min(resolution.x, resolution.y) * 2.0;
	position.x += sin(time) * 0.527;
	position.y -= cos(time) * 0.527;
	vec3 color;
	
	float circle = pow(position.x, 2.0) + pow(position.y, 2.0);

	if ( circle < 0.1 &&
	     circle > 0.095
	     ) {
		color = vec3(255, 0, 255);
	}
	else {
		color = vec3(0);
	}
	
	
	gl_FragColor = vec4(color, 1.0);

}