#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// simple distance field

float function(vec2 p) {
	return abs(length(p) - 0.5);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )*2.0 - 1.0;

	
	float c = function(position) * 20.0;
	vec3 color;
	color = vec3(0.8+sin(time * (position.x*0.1)), 0.9+cos(time / (position.y*10.0)), 1.0+cos(time * (position.y*0.01))) * c;
	
	gl_FragColor = vec4(color*3.0, 1.0);

}