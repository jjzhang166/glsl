#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// simple distance field

float function(vec2 p) {
	return length(p - vec2(0.0,0.0)) - 0.5;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )*2.0 - 1.0;

	
	float c = function(position) * 20.0;
	vec3 color;
	if (c < 0.0) {
		color = vec3(1.0, 0.9, 0.8) * -c;
	} else {
		color = vec3(0.8, 0.9, 1.0) * c;
	}
	
	gl_FragColor = vec4(color, 1.0);

}